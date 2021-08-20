//
//  KanbanView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 31/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct KanbanView: View {
    @ObservedObject var eventViewModel : EventsViewModel
    var daysArray : [String]
    var datesArray : [String]
    //var eventsInWeek : [[Event]]
    @ObservedObject var eventsInWeek : EventsInWeek
    var helper : DateHelper
    var selectedDayIndex : Int = 7
    @EnvironmentObject var currentEvent : Event
    @ObservedObject var loadingIndicator : LoadingIndicator
    
    
    var body: some View {
        HStack(spacing: 0){
            MonthView(eventViewModel : eventViewModel, loadingIndicator: loadingIndicator).environmentObject(currentEvent)
            ScrollViewReader{ scrollView in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 0){
                        ForEach(0..<14, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0){
                                    KanbanHeaderView(day: daysArray[i], dayOfMonth: datesArray[i], currentDay: selectedDayIndex, indexDay: i)
                                    if (self.eventsInWeek.weekevents.count > 0) {
                                        if (self.eventsInWeek.weekevents[i].count > 0){
                                            List {
                                                ForEach(eventsInWeek.weekevents[i], id: \.id){ event in
                                                    EventView(event: event, helper: helper, eventViewModel: eventViewModel)
                                                        .padding([.leading, .trailing], 2)
                                                        .padding([.bottom], 8)
                                                        .shadow(color: Color.black.opacity(0.1), radius: 0.8, x: 0.0, y: 1.0)
                                                        .contentShape(Rectangle())
                                                        .onTapGesture {
                                                            self.currentEvent.summary = ""
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
                                                        }
                                                }
                                            }.padding(.horizontal, -5).workaroundForVerticalScrollingBugInMacOS()
                                        } else {
                                            AddScheduleButtonView()
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(width: 310)
                                .background(Color("kanbanInside"))
                                .cornerRadius(4)
                            }
                            .id(i)
                            .padding([.top, .leading, .bottom], 15)
                        }
                    }
                    .padding([.trailing], 15)
                    
                }.onAppear(){
                    scrollView.scrollTo(7, anchor: .leading)
                }
            }
        }
    }
}

struct KanbanView_Previews: PreviewProvider {
    static var currentEvent = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    static var eventII = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    
    
    static var eventsInWeek = EventsInWeek()
    static var helper  = DateHelper()
    static var eventViewModel = EventsViewModel()
    static var daysArray = [String]()
    static var datesArray = [String]()
    static var selectedDayIndex : Int = 9
    static var loadingIndicator = LoadingIndicator()
    
    static var previews: some View {
        KanbanView(eventViewModel: eventViewModel, daysArray: daysArray, datesArray: datesArray, eventsInWeek: eventsInWeek, helper: helper, loadingIndicator: loadingIndicator).environmentObject(currentEvent)
    }
}
