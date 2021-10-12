//
//  HomeScreen.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 08/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI
import AppKit



struct HomeScreen: View {
    @State private var date = Date()
    @StateObject var loadingIndicator = LoadingIndicator()
    @StateObject var eventsInWeek = EventsInWeek()
    @State var currentEvent : Event = Event(id: "23274264256", summary: "Bless Derin", startDate: "2012-07-19T02:30:00-06:00", endDate: "2012-07-21T02:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Lekki", account: "knightbenax@gmail.com")
    
    @State var today : Date!
    var reloadNotificationChanged = NotificationCenter.default.publisher(for: .reload)
    var appBecomesActive = NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @StateObject var datesArranger  = DatesArranger()
    let helper = DateHelper()
    let authViewModel = AuthViewModel()
    @StateObject var eventViewModel = EventsViewModel()
    
    func checkNewDayAndLoad(){
        var currentDay = today ?? Date()
        if (Calendar.current.isDateInToday(currentDay)){//meaning we are still in the same day
            loadData()
        } else { //means the day has changed from the last day, we had this opened or refreshed
            currentDay = Date()
            datesArranger.datesArray.removeAll()
            datesArranger.daysArray.removeAll()
            for i in 0..<14 {
                let dayDiff = i - 7
                let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: currentDay)
                let index = helper.getDayOfWeek(today: nextDate!)! - 1
                datesArranger.datesArray.append(helper.formatDateToBeauty(thisDate: nextDate!, type: "day"))
                datesArranger.daysArray.append(daysOfWeek[index])
            }
            loadData()
        }
    }
    
    func loadData(){
        DispatchQueue.main.async {
            loadingIndicator.loading = true
        }
        self.eventsInWeek.weekevents.removeAll()
        eventViewModel.fetchEvents(completion: { eventsInDaysArray in
            DispatchQueue.main.async {
                self.loadingIndicator.loading = false
                self.eventsInWeek.weekevents = eventsInDaysArray
                //check if there any events on the selected day or 7th day and display the details
                if (self.eventsInWeek.weekevents[7].count > 0){
                    let event = self.eventsInWeek.weekevents[7][0]
                    self.eventsInWeek.currentEvent = event
                }
            }
        })
    }
    
    func becameActive(){
        let difference = helper.getMinutesDifferenceFromTwoDates(start: eventsInWeek.lastActiveDate, end: Date())
        if (difference >= 60){
            checkNewDayAndLoad()
            eventsInWeek.lastActiveDate = Date()
        }
    }
    
    func createValues(){
        eventsInWeek.lastActiveDate = Date()
        datesArranger.datesArray.removeAll()
        datesArranger.daysArray.removeAll()
        today = Date()
        for i in 0..<14 {
            let dayDiff = i - 7
            let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: today)
            let index = helper.getDayOfWeek(today: nextDate!)! - 1
            datesArranger.datesArray.append(helper.formatDateToBeauty(thisDate: nextDate!, type: "day"))
            datesArranger.daysArray.append(daysOfWeek[index])
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            TopView(loadingIndicator: loadingIndicator) //loading: loadingIndicator.loading
            if (authViewModel.isLoggedIn()){
                KanbanView(eventViewModel: eventViewModel, datesArranger: datesArranger, eventsInWeek: eventsInWeek, helper: helper, loadingIndicator: loadingIndicator)
                    .onAppear(){
                        self.loadData()
                    }.environmentObject(eventsInWeek.currentEvent)
            } else {
                LoginView(authViewModel: authViewModel)
            }
        
        }.frame(minWidth: 1280,  maxWidth: .infinity, minHeight: 780, maxHeight: .infinity)
        .background(Color("darkBgColor"))
        .onAppear(){
            self.createValues()
        }
        .onReceive(reloadNotificationChanged, perform: { _ in
            checkNewDayAndLoad()
        }).onReceive(appBecomesActive, perform: { _ in
            becameActive()
        })
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

class HomeHostingController: NSHostingController<HomeScreen> {

    @objc required dynamic init?(coder: NSCoder) {
           super.init(coder: coder, rootView: HomeScreen())
    }

}

