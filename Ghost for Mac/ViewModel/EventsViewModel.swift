//
//  EventsViewModel.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 25/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import AppKit

class EventsViewModel: BaseViewModel, ObservableObject {
    
    @Published public var events : [Event] = {
        return []
    }()
    
    var eventsInWeek  = [[Event]]()
    var fetchedDay = 0
    var needContacts : Bool = false
    var contacts = Array<Contact>()
    
    func fetchEvents(completion: @escaping (_ eventsInDaysArrays : [[Event]]) -> ()){
        
        var calendars = storeHelper.getCalendars(delegate: getDelegate())
        calendars = calendars.removingDuplicates()
        fetchEventsProtocol(calendars: calendars, completion: { eventsInDaysArrays in
            completion(eventsInDaysArrays)
        })
    }
    
    
    func getCalendarName(event : Event) -> String{
        let calendar = storeHelper.getSingleSavedCalendar(id: event.account!, delegate: getDelegate())
        return calendar[0].value(forKey: "name") as? String ?? ""
    }
    
    func getCalendarTextColor(event : Event) -> NSColor{
        let account = storeHelper.getSingleSavedAccount(name: event.account!, delegate: getDelegate())
        let color = account[0].value(forKey: "color") as! String
        let uicolor = NSColor(hex: color)
        let textColor = uicolor?.isDarkColor == true ? NSColor(hex: "#FFFFFF") : NSColor(hex: "#000000")
        return textColor ?? NSColor.black
    }
    
    func getCalendarTextBackgroundColor(event : Event) -> NSColor{
        let account = storeHelper.getSingleSavedAccount(name: event.account!, delegate: getDelegate())
        let color = account[0].value(forKey: "color") as! String
        let uicolor = NSColor(hex: color)
        return uicolor ?? NSColor.black
    }
    
    
    let group = DispatchGroup()
    
    func fetchEventsProtocol(calendars: [GoogleCalendar], completion: @escaping (_ eventsInDaysArrays : [[Event]]) -> ()){
        
        events.removeAll()
        let next_week = getTimeAndDate(day: 7)
        let last_week = getTimeAndDate(diff: -1, day: -7)
        calendars.forEach({
            group.enter()
            let account = $0.owner
            getDelegate().currentAccount = $0.owner
            googleService.getGoogleCalendarEvents(calendar_id: $0.id, startDate: next_week, endDate: last_week, completion: { [self](result: Result<Any, Error>) in
                switch (result){
                case .success(let data):
                    let dataItems = data as! NSDictionary
                    let items = dataItems.object(forKey: "items") as! NSArray
                    //print(data)
                    self.parseEvents(items: items, account: account)
                    group.leave()
                    break
                case .failure(let error):
                    print(error)
                    let code = error.asAFError?.responseCode
                    self.manageError(responseCode: code!)
                    group.leave()
                    break
                }
            });
        })
        
        
        
        group.notify(queue: DispatchQueue.main) { [self] in
            breakEventsIntoWeekDays(last_week: last_week, next_week: next_week)
            completion(eventsInWeek)
        }
    }
    
    
    func parseEvents(items: NSArray, account : String){
        items.forEach {(item) in
            let data = item as! NSDictionary
            
            var type = ""
            var startDateValue = ""
            var endDateValue = ""
            var colorId = ""
            var markedAsDone = false
            var descriptionTemp = ""
            var location : String? = ""
            var hasTime = false
            
            if (data.object(forKey: "conferenceData") as? NSDictionary) != nil {
                type = "#meeting"
            } else {
                type = "#work"
            }
            
            let startDate = data.object(forKey: "start") as! NSDictionary
            let endDate = data.object(forKey: "end") as! NSDictionary
            
            if let dateTime = startDate.object(forKey: "dateTime") as? String{
                startDateValue = dateTime
            } else {
                startDateValue = startDate.object(forKey: "date") as! String
            }
            
            if let dateTime = endDate.object(forKey: "dateTime") as? String{
                endDateValue = dateTime
                hasTime = true
            } else {
                endDateValue = endDate.object(forKey: "date") as! String
            }
        
            if let tempColorId = data.object(forKey: "colorId") as? String{
                colorId = tempColorId
            } else {
                colorId = "11"
            }
            
            if let locationTemp = data.object(forKey: "location") as? String{
                location = locationTemp
            }
            
            if let description = data.object(forKey: "description") as? String{
                if (description == "Ghost marked as done" || description.contains("Ghost marked as done")){
                    markedAsDone = true
                }
                
                if (description.contains("Join Zoom Meeting") || description.contains("join zoom meeting") || description.contains("Ghost Meeting")){
                    type = "#meeting"
                } else if (description.contains("Ghost Gym")){
                    type = "#gym"
                } else if (description.contains("Ghost Task")){
                    type = "#task"
                } else if (description.contains("Ghost Work")){
                    type = "#work"
                }
                
                descriptionTemp = description
            }
            
            var savedAttendees : Array<String>!
            
            if let attendees = data.object(forKey: "attendees") as? NSArray {
                savedAttendees = Array<String>()
                //there are attendees, load contacts
                needContacts = true
                //save all attendees
                for attendee in attendees {
                    let attendeeData = attendee as! NSDictionary
                    savedAttendees.append(attendeeData.object(forKey: "email") as! String)
                    
                }
                //save the creator. this is for cases where the event wasn't created by me or
                //we have more than one attendee
                if let creator = data.object(forKey: "creator") as? NSDictionary {
                    let creatorEmail = creator.object(forKey: "email" ) as! String
                    if ((savedAttendees) != nil){
                        savedAttendees.append(creatorEmail)
                    }
                }
                
                if let myIndex = savedAttendees.firstIndex(of: "knightbenax@gmail.com"){
                    savedAttendees.remove(at: myIndex)
                }
                
                savedAttendees = savedAttendees.removingDuplicates()
            }
            
            
            let eventStartDate = getDatesForComparisonBool(hasTime: hasTime, thisDate: startDateValue)
            let eventEndDate = getDatesForComparisonBool(hasTime: hasTime, thisDate: endDateValue)
            
            //I am getting the number of days an event spans for. We would remove 1 from this number since Google makes ALL-DAy events end the next day
            let number = Calendar.current.numberOfDaysBetween(eventStartDate, and: eventEndDate) - 1
            
            if (number <= 1){
                //this is an all day event i.e Event that ends the same day
                let newEvent = Event(id: data.object(forKey: "id") as! String,
                                     summary: data.object(forKey: "summary") as! String,
                                     startDate: startDateValue,
                                     endDate: endDateValue,
                                     colorId: colorId,
                                     type: type,
                                     hasTime: hasTime, attendees: savedAttendees,
                                     markedAsDone: markedAsDone, description: descriptionTemp, location: location, account: account)
                events.append(newEvent)
            } else {
                var newStartDate = eventStartDate
                var newEndDate = eventStartDate
                for _ in 0..<number {
                    
                    newEndDate.addDays(n: 1)
                    //here we want to create events to fill in the seperate days for each day the event occurs on too
                    let duplicateEvent = Event(id: data.object(forKey: "id") as! String,
                                         summary: data.object(forKey: "summary") as! String,
                                         startDate: getStringFromEventDate(hasTime: hasTime, thisDate: newStartDate),
                                         endDate: getStringFromEventDate(hasTime: hasTime, thisDate: newEndDate),
                                         colorId: colorId,
                                         type: type,
                                         hasTime: hasTime, attendees: savedAttendees,
                                         markedAsDone: markedAsDone, description: descriptionTemp, location: location, account: account)

                    newStartDate = newEndDate
                    events.append(duplicateEvent)
                }
                
            }
            
            
            events = events.sorted(by: { $0.startDate < $1.startDate})
        }
        
        
    }
    
    func breakEventsIntoWeekDays(last_week: String, next_week: String){
        
        let next_week_date = getDateFromString(dateInString: next_week)
        var last_week_date = getDateFromString(dateInString: last_week)
        
        while last_week_date <= next_week_date {
            var thisEvents = [Event]()
            thisEvents = events.filter({ Calendar.current.isDate(getDatesForComparison(event: $0), inSameDayAs: last_week_date) })
            eventsInWeek.append(thisEvents)
            last_week_date = Calendar.current.date(byAdding: .day, value: 1, to: last_week_date)!
        }
        
    }
    
    func fetchContacts (){
        //once created, don't fetch again
        if (contacts.count <= 0){
            googleService.getContacts(completion: {(result : Result<Any, Error>) in
                switch (result){
                case .success(let data):
                    let contactsData = data as! NSDictionary
                    if (contactsData.count > 0){
                        self.parseContacts(item: contactsData)
                    }
                    break
                case .failure(let error):
                    print("error from fetching contacts")
                    let code = error.asAFError?.responseCode
                    self.manageError(responseCode: code!)
                    break
                }
            })
        }
        
    }
    
    func parseContacts(item: NSDictionary){
        let connections = item.object(forKey: "connections") as! NSArray
        
        contacts = Array<Contact>()
        
        for connection in connections {
            
            var emailValue = ""
            let connection = connection as! NSDictionary
            let names =  connection.object(forKey: "names") as! NSArray
            let name = names[0] as! NSDictionary
            
            let photos =  connection.object(forKey: "photos") as! NSArray
            let photo = photos[0] as! NSDictionary
            
            var emailsArray = [String]()
            
            if let emails = connection.object(forKey: "emailAddresses") as? NSArray {
                emails.forEach({
                    let email = $0 as! NSDictionary
                    emailValue = email.object(forKey: "value") as! String
                    emailsArray.append(emailValue)
                })
            }
            
            
            
            contacts.append(Contact(name: name.object(forKey: "displayNameLastFirst") as! String,
                                    email: emailsArray, photo: photo.object(forKey: "url") as! String))
        }
    }
    
    
    func getCalendarsCount() -> Int{
        return storeHelper.getSavedCalendars(delegate: getDelegate()).count
    }
    
}
