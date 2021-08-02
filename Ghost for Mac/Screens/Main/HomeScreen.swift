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
    @State private var loading = false
    @State var events: [Event] = []
    @State var eventsInWeek  = [[Event]]()
    
    var today : Date!
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var daysArray = [String]()
    var datesArray = [String]()
    let helper = DateHelper()
    let authViewModel = AuthViewModel()
    let eventViewModel = EventsViewModel()
    
    init() {
        authViewModel.doStart()
        today = Date()
        for i in 0..<14 {
            let dayDiff = i - 7
            let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: today)
            let index = helper.getDayOfWeek(today: nextDate!)! - 1
            datesArray.append(helper.formatDateToBeauty(thisDate: nextDate!, type: "day"))
            daysArray.append(daysOfWeek[index])
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            TopView(loading: loading)
            if (authViewModel.isLoggedIn()){
                KanbanView(eventViewModel: eventViewModel, daysArray: daysArray, datesArray: datesArray, eventsInWeek: eventsInWeek, helper: helper)
                    .onAppear(){
                    eventViewModel.fetchEvents(completion: {
                        
                        self.events = eventViewModel.events
                        self.eventsInWeek = eventViewModel.eventsInWeek
                        print(eventViewModel.eventsInWeek)
                        if (events.count <= 0){
                            if (eventViewModel.getCalendarsCount() <= 0){
                                //fetchMessage = "Open up Ghost on your iPhone to sync calendars"
                            } else {
                                //fetchMessage = "You have no events or tasks for today! Time to read or catch up on that series"
                            }
                        }
                        
                    })
                    }
            } else {
                LoginView(authViewModel: authViewModel)
            }
        
        }.frame(minWidth: 700,  maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .background(Color("darkBgColor"))
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

