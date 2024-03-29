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
//    var daysArray : [String]
//    var datesArray : [String]
    @ObservedObject var datesArranger  : DatesArranger
    //var eventsInWeek : [[Event]]
    @ObservedObject var eventsInWeek : EventsInWeek
    var helper : DateHelper
    var selectedDayIndex : Int = 7
    @EnvironmentObject var currentEvent : Event
    @ObservedObject var loadingIndicator : LoadingIndicator
    var hideMonthSiderNotificationChanged = NotificationCenter.default.publisher(for: .hideMonthSidebar)
    var hideBacklogSiderNotificationChanged = NotificationCenter.default.publisher(for: .hideBacklogSidebar)
    @AppStorage("hideMonthSidebar") var hideMonthSidebar = true
    @AppStorage("hideBacklogSidebar") var hideBacklogSidebar = false
    
    func showSidebarIfHidden(){
        withAnimation{
            hideMonthSidebar = true
        }
    }
    
    func showBacklogIfHidden(){
        withAnimation{
            hideBacklogSidebar = true
        }
    }
    
    var body: some View {
        HStack(spacing: 0){
            if (hideMonthSidebar){
                MonthView(eventViewModel : eventViewModel, loadingIndicator: loadingIndicator).environmentObject(currentEvent)
            }
            ScrollViewReader{ scrollView in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 0){
                        if (datesArranger.datesArray.count > 0){
                            ForEach(0..<14, id: \.self) { i in
                                VStack(alignment: .leading, spacing: 0) {
                                    VStack(alignment: .leading, spacing: 0){
                                        KanbanHeaderView(day: datesArranger.daysArray[i], dayOfMonth: datesArranger.datesArray[i], currentDay: selectedDayIndex, indexDay: i)
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
                                                                self.eventsInWeek.currentEvent = event
                                                                showSidebarIfHidden()
                                                            }
                                                    }
                                                }.padding(.horizontal, -5)
                                                    .onTapGesture(count: 2) {
                                                    withAnimation {
                                                        scrollView.scrollTo(7, anchor: .leading)
                                                    }
                                                }.workaroundForVerticalScrollingBugInMacOS()
                                            } else {
                                                EmptyStateView()
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
                            }.onAppear(){
                                withAnimation {
                                    scrollView.scrollTo(7, anchor: .leading)
                                }
                            }
                        }
                    }
                    .padding([.trailing], 15)
                }.onTapGesture(count: 2) {
                    withAnimation {
                        scrollView.scrollTo(7, anchor: .leading)
                    }
                }
            }
            if (hideBacklogSidebar){
                BackLogView()
            }
        }.onReceive(hideMonthSiderNotificationChanged, perform: { _ in
            withAnimation{
                hideMonthSidebar.toggle()
            }
        }).onReceive(hideBacklogSiderNotificationChanged, perform: { _ in
            withAnimation{
                hideBacklogSidebar.toggle()
            }
        })
    }
}

struct KanbanView_Previews: PreviewProvider {
    static var currentEvent = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    static var eventII = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    
    
    static var eventsInWeek = EventsInWeek()
    static var helper  = DateHelper()
    static var eventViewModel = EventsViewModel()
    static var datesArranger  = DatesArranger()
    //static var datesArray = [String]()
    static var selectedDayIndex : Int = 9
    static var loadingIndicator = LoadingIndicator()
    
    static var previews: some View {
        KanbanView(eventViewModel: eventViewModel, datesArranger: datesArranger, eventsInWeek: eventsInWeek, helper: helper, loadingIndicator: loadingIndicator).environmentObject(currentEvent)
    }
}
