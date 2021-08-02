//
//  ViewController.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 15/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Cocoa
import Kingfisher
import GAppAuth

class MainViewController: BaseViewController {

    @IBOutlet weak var weekView: NSCollectionView!
    @IBOutlet weak var inspirationImage: NSImageView!
    @IBOutlet weak var monthLabel: NSTextField!
    @IBOutlet weak var logInView: NSView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var profileImage: NSImageView!
    
    let eventItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "EventItemIdentifier")
    
    @IBOutlet weak var eventsTable: NSTableView!
    let today = Date()
    var fetchedDay = 0
    var wakeup = false
    let daysOfWeek = ["SUN", "MON", "TUES", "WED", "THUR", "FRI", "SAT"]
    var urgentCalendar = ""
    var importantCalendar = "primary"
    var selectedCalendar = ""
    
    var contacts : Array<Contact>!
    
    @IBOutlet weak var ghost_empty_image: NSImageView!
    @IBOutlet weak var emptyView: NSView!
    @IBOutlet weak var emptyTaskTextView: NSTextField!
    //We don't want to load the contacts everytime. It takes effort and let's reduce CO2 waste.
    var needContacts : Bool = false
    
    
    private(set) lazy var events : [Event] = {
          return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        selectedCalendar = importantCalendar
        GAppAuth.shared.retrieveExistingAuthorizationState()
        checkRegistration()
        if (store.userLoggedIn()){
            logInView.isHidden = true
            getCalendarEvents()
        } else {
            logInView.isHidden = false
        }
        getDailyView()
        setCollectionFlowLayout()
    }
    
    
    func setUpTable(){
        eventsTable.delegate = self
        eventsTable.dataSource = self
        eventsTable.backgroundColor = NSColor.clear
        eventsTable.focusRingType = .none
        eventsTable.selectionHighlightStyle = .none
        eventsTable.enclosingScrollView?.contentInsets = NSEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0)
               
               //Context Menu for the HistoryTable
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Delete", action: #selector(tableViewDeleteItemClicked(_:)), keyEquivalent: ""))
        eventsTable.menu = menu
    }
    
    @objc private func tableViewDeleteItemClicked(_ sender: AnyObject) {
           guard eventsTable.clickedRow >= 0 else { return }
    }
    
    
    func getCalendarEvents(){
       startProgressLoading()
        let next_week = getTimeAndDate(diff: 7, day: fetchedDay)
        let last_week = getTimeAndDate(diff: -7, day: fetchedDay)
        googleService.getGoogleCalendarEvents(calendar_id: selectedCalendar, startDate: last_week, endDate: next_week, completion: { (result: Result<Any, Error>) in
            switch (result){
            case .success(let data):
                 let dataItems = data as! NSDictionary
                 let items = dataItems.object(forKey: "items") as! NSArray
                 self.parseEvents(items: items)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @IBAction func refreshCalendar(_ sender: Any) {
        events.removeAll()
        getCalendarEvents()
    }
    
    @IBAction func switchCalender(_ sender: Any) {
        let sender = sender as! NSSegmentedControl
        switch sender.selectedSegment {
        case 0:
            selectedCalendar = importantCalendar
            break
        case 1:
            selectedCalendar = urgentCalendar
            break
        default:
            break
        }
        
        events.removeAll()
        getCalendarEvents()
    }
    
    private func startProgressLoading(){
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)
    }
    
    private func endProgressLoading(){
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
    }
    
    func parseEvents(items: NSArray){
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
            
            
            
            //print(savedAttendees)
            
//            events.append(Event(id: data.object(forKey: "id") as! String,
//                                summary: data.object(forKey: "summary") as! String,
//                                startDate: startDateValue,
//                                endDate: endDateValue,
//                                colorId: colorId,
//                                type: type,
//                                hasTime: hasTime, attendees: savedAttendees,
//                                markedAsDone: markedAsDone, description: descriptionTemp, location: location))
        }
        
        
        
        if (needContacts) {
            //fetch the contacts, we would reload the table when done
            fetchContacts()
        } else {
            eventsTable.reloadData()
            endProgressLoading()
        }
        
        if (wakeup){
            endProgressLoading()
            wakeup = false
        }
        
        if (events.count == 0){
            emptyView.isHidden = false
            setEmptyTaskTextViewLabel(calendar: selectedCalendar)
        } else {
            emptyView.isHidden = true
        }
        
        //events.count == 0 ? emptyView.isHidden = false : emptyView.isHidden = true
    }
    
    
    //We are going to be fetching contacts once. It's a fucking
       //tedious process to be doing all over and over again
       func fetchContacts (){
           //once created, don't fetch again
           if (contacts == nil){
               googleService.getContacts(completion: {(result : Result<Any, Error>) in
                   switch (result){
                   case .success(let data):
                       self.parseContacts(item: data as! NSDictionary)
                       break
                   case .failure(let error):
                       print("contacts_error")
                       let code = error.asAFError?.responseCode
                       self.manageError(responseCode: code!)
                       break
                   }
                     
               })
           } else {
               //So the user needs contacts but contacts have already been loaded, so
               //just reload the table
            eventsTable.reloadData()
            endProgressLoading()
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
               
               if let emails = connection.object(forKey: "emailAddresses") as? NSArray {
                   let email = emails[0] as! NSDictionary
                   emailValue = email.object(forKey: "value") as! String
               }
               
//               contacts.append(Contact(name: name.object(forKey: "displayNameLastFirst") as! String,
//                                       email: emailValue, photo: photo.object(forKey: "url") as! String))
           }
           
           //reload table now
           eventsTable.reloadData()
           endProgressLoading()
       }
    
    
    func setEmptyTaskTextViewLabel(calendar: String){
        switch calendar {
        case importantCalendar:
            ghost_empty_image.isHidden = false
            emptyTaskTextView.stringValue = "You have no important long-term things for today. It's fine but don't make this a regular occurence"
        case urgentCalendar:
            ghost_empty_image.isHidden = false
            emptyTaskTextView.stringValue = "You have no events, tasks or even fires to put out today! Time to read or catch up on that series"
        case "nourgentcalendar":
            ghost_empty_image.isHidden = true
            emptyTaskTextView.stringValue = "You haven't selected a calender to use for urgent tasks. Select one from settings"
        default:
            break
        }
    }
    
    
    func checkRegistration(){
        if GAppAuth.shared.isAuthorized() {
            let authorization = GAppAuth.shared.getCurrentAuthorization()
            let tokenResponse = authorization?.authState.lastTokenResponse
            let accessToken : String = (tokenResponse?.accessToken)!
            let refreshToken : String = (tokenResponse?.refreshToken)!
            let interval = Date().timeIntervalSince((tokenResponse?.accessTokenExpirationDate)!)
            let accessExpiryDate : TimeInterval = interval
            let values : NSMutableDictionary = ["access_token": accessToken,
                                                "refresh_token": refreshToken,
                                                "expires_in": accessExpiryDate]
            store.saveUser(result: values)
            print("saved user")
        }
    }
    
    override var representedObject: Any? {
        didSet {
            checkRegistration()
        }
    }
    
    
    
    func signInGoogle(){
        do {
            try GAppAuth.shared.authorize { auth in
                if auth {
                    self.checkRegistration()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func signInGoogleAction(_ sender: Any) {
        signInGoogle()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    fileprivate func setCollectionFlowLayout(){
        let nib = NSNib(nibNamed: "EventItem", bundle: nil)
        weekView.register(nib, forItemWithIdentifier: eventItemIdentifier)
        weekView.delegate = self
        weekView.dataSource = self
        weekView.enclosingScrollView?.borderType = .noBorder
        monthLabel.stringValue = formatDateToBeauty(thisDate: today, type: "year")
        weekView.enclosingScrollView?.backgroundColor = NSColor.clear
        weekView.backgroundColors = [NSColor.clear]
        
        weekView.enclosingScrollView?.scrollerInsets = NSEdgeInsets.init(top: 0, left: 0, bottom: -20, right: 0)
       
           /*let flowLayout = NSCollectionViewFlowLayout()
           flowLayout.itemSize = NSSize(width: sizeOfCell, height: sizeOfCell)
           flowLayout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           flowLayout.minimumLineSpacing = 0
           flowLayout.minimumInteritemSpacing = 0
           colorList.collectionViewLayout = flowLayout*/
    }
    
    func getDailyView(){
     
        let url = URL(string: "https://pbs.twimg.com/profile_images/1258870922678861824/STiPgl8r_400x400.jpg")
        /*KingfisherManager.shared.retrieveImage(with: url!, options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired), .keepCurrentImageWhileLoading, .transition(.none)]) { result in
            // Do something with `result`
            //try print(result.get().image)
            do {
                let image = try result.get().image
                self.imageFitWell(image: image)
            } catch (let error){
                print(error)
            }
        }*/
       let downloader = ImageDownloader.default
        downloader.downloadImage(with: url!, completionHandler:  { result in
            switch result {
            case .success(let value):
                let image = value.image
                self.imageFitWell(image: image)
            case .failure(let error):
                print(error)
            }
        })
    }

  
    private func imageFitWell(image: NSImage){
           self.profileImage.layer? = CALayer()
           self.profileImage.layer?.contentsGravity = .resizeAspectFill
           self.profileImage.layer?.contents = image
           self.profileImage.wantsLayer = true
        self.profileImage.layer?.cornerRadius = 21
        self.profileImage.layer?.borderColor = NSColor.white.cgColor
        self.profileImage.layer?.borderWidth = 2
       }
    
    
    func getDayOfWeek(today: Date) -> Int? {
          let myCalendar = Calendar(identifier: .gregorian)
          let weekDay = myCalendar.component(.weekday, from: today)
          return weekDay
      }
    
    func formatDateToBeauty(thisDate: Date, type: String = "day") -> String{
        switch type {
        case "year":
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "MMM yyyy"
             return dateFormatterPrint.string(from: thisDate)
        case "month":
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "d MMM"
            return dateFormatterPrint.string(from: thisDate)
        default:
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "dd"
             return dateFormatterPrint.string(from: thisDate)
        }
    }

}

extension MainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let i = indexPath.item
        let cell = collectionView.makeItem(withIdentifier: eventItemIdentifier, for: indexPath) as? EventItem
        
        let dayDiff = i - 7
        let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: today)
        cell?.todayDotView.isHidden = true
        
        if (i == 7){
            //this is today 
            cell?.todayDotView.isHidden = false
        }
        
        let index = getDayOfWeek(today: nextDate!)! - 1
        cell?.dateText.stringValue = formatDateToBeauty(thisDate: nextDate!)
        cell?.dayText.stringValue = daysOfWeek[index]
        return cell!
    }
    
}

extension MainViewController: NSTableViewDelegate, NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
        print("width")
        return tableView.bounds.width
        //tableView.tableColumns[column].width
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
           
        let event = events[row]
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("EventTableCell"), owner: self) as? EventTableCell
        
        if (event.hasTime){
            cell?.startTimeLabel.stringValue = formatDateToTimeOnly(thisDate: event.startDate) + " - "
            cell?.endTimeLabel.stringValue = formatDateToTimeOnly(thisDate: event.endDate)
        } else {
            cell?.startTimeLabel.stringValue = "ALL DAY"
            cell?.endTimeLabel.stringValue = ""
        }
        
        //print(tableView.bounds.width)
        let width = (tableView.frame.width - 5)
        tableColumn?.width = width
        //tableView.tableColumns[column].width = table
        
        if (event.markedAsDone){
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: event.summary)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell?.eventSummaryLabel.attributedStringValue = attributeString
        } else {
            cell?.eventSummaryLabel.attributedStringValue = NSAttributedString.init()
            cell?.eventSummaryLabel.stringValue = event.summary
        }
        
        switch event.type {
        case "#meeting":
            cell?.eventTypeLabel.stringValue = "Meeting"
        case "#gym":
            cell?.eventTypeLabel.stringValue = "Gym"
        case "#task":
            cell?.eventTypeLabel.stringValue = "Task"
        default:
            cell?.eventTypeLabel.stringValue = "Work"
        }
        
        cell?.setColor(eventType: event.type)
        
        return cell
    }
    
}

