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
    //@State var eventsInWeek = [[Event]]()
    @State var currentEvent : Event = Event(id: "23274264256", summary: "Bless Derin", startDate: "2012-07-19T02:30:00-06:00", endDate: "2012-07-21T02:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Lekki", account: "knightbenax@gmail.com")
    
    @State var today : Date!
    var reloadNotificationChanged = NotificationCenter.default.publisher(for: .reload)
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
//    @State var daysArray : [String] = [String]()
//    @State var datesArray : [String] = [String]()
    @StateObject var datesArranger  = DatesArranger()
    let helper = DateHelper()
    let authViewModel = AuthViewModel()
    @StateObject var eventViewModel = EventsViewModel()
    
    func checkNewDayAndLoad(){
        let currentDay = today ?? Date()
        if (Calendar.current.isDateInToday(currentDay)){//meaning we are still in the same day
            loadData()
            print("change data")
        } else {
            print("change day")
            datesArranger.datesArray.removeAll()
            datesArranger.daysArray.removeAll()
            print(currentDay)
            for i in 0..<14 {
                let dayDiff = i - 7
                let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: currentDay)
                let index = helper.getDayOfWeek(today: nextDate!)! - 1
                datesArranger.datesArray.append(helper.formatDateToBeauty(thisDate: nextDate!, type: "day"))
                datesArranger.daysArray.append(daysOfWeek[index])
            }
            print(datesArranger.datesArray[7])
        }
    }
    
    func loadData(){
        self.eventsInWeek.weekevents.removeAll()
        loadingIndicator.loading = true
        eventViewModel.fetchEvents(completion: { eventsInDaysArray in
            DispatchQueue.main.async {
                self.eventsInWeek.weekevents = eventsInDaysArray
                self.loadingIndicator.loading = false

                //check if there any events on the selected day or 7th day and display the details
                if (self.eventsInWeek.weekevents[7].count > 0){
                    let event = self.eventsInWeek.weekevents[7][0]
                    self.currentEvent.id = event.id
                    self.currentEvent.summary = event.summary
                    self.currentEvent.startDate = event.startDate
                    self.currentEvent.endDate = event.endDate
                    self.currentEvent.colorId = event.colorId
                    self.currentEvent.type = event.type
                    self.currentEvent.hasTime =  event.hasTime
                    self.currentEvent.markedAsDone = event.markedAsDone
                    self.currentEvent.description = event.description
                    self.currentEvent.account = event.account
                    self.currentEvent.location = event.location
                    self.currentEvent.conferenceData = event.conferenceData
                }
            }
        })
    }
    
    func createValues(){
        print("fresg")
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
                    }.environmentObject(currentEvent)
            } else {
                LoginView(authViewModel: authViewModel)
            }
        
        }.frame(minWidth: 700,  maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .background(Color("darkBgColor"))
        .onAppear(){
            self.createValues()
        }
        .onReceive(reloadNotificationChanged, perform: { _ in
            checkNewDayAndLoad()
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

