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
    @State var loading = false
    @State var eventsInWeek  = [[Event]]()
    
    var today : Date!
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var daysArray = [String]()
    var datesArray = [String]()
    let helper = DateHelper()
    let authViewModel = AuthViewModel()
    let eventViewModel = EventsViewModel()
    
    init() {
        //authViewModel.doStart()
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
                        eventViewModel.fetchEvents(completion: { eventsInDaysArray in
                            self.eventsInWeek = eventsInDaysArray
                            self.loading = false
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

