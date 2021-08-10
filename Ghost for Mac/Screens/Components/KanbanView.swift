//
//  KanbanView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 31/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct KanbanView: View {
    var eventViewModel : EventsViewModel
    var daysArray : [String]
    var datesArray : [String]
    var eventsInWeek : [[Event]]
    var helper : DateHelper
    
    
    var body: some View {
        HStack(spacing: 0){
            MonthView()
            ScrollViewReader{ scrollView in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 0){
                        ForEach(0..<14, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0){
                                    Text(daysArray[i] + ", " +  datesArray[i]).font(.custom("Overpass-Regular", size: 14))
                                        .foregroundColor(Color("textColor"))
                                        .padding([.leading, .trailing], 6)
                                        .padding([.top], 10)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                    if (self.eventsInWeek.count > 0) {
                                        if (self.eventsInWeek[i].count > 0){
                                            List {
                                                ForEach(eventsInWeek[i]){ event in
                                                    EventView(event: event, helper: helper, eventViewModel: eventViewModel)
                                                        .padding([.leading, .trailing], 2)
                                                        .padding([.bottom], 8)
                                                        .shadow(color: Color.black.opacity(0.1), radius: 0.8, x: 0.0, y: 1.0)
                                                }
                                            }.padding(.horizontal, -5).workaroundForVerticalScrollingBugInMacOS()
                                        } else {
                                            Button(action: {print("balls")}) {
                                                HStack{
                                                    Image(systemName: "calendar.badge.plus")
                                                        .font(.system(size: 16, weight: .bold))
                                                        .padding([.leading], 10)
                                                    Text("Add Schedule")
                                                        .padding([.top, .bottom], 6)
                                                        .padding([.trailing], 10)
                                                        .padding([.leading], 2)
                                                }.frame(minWidth: 0, maxWidth: .infinity)
                                                .frame(height: 30)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .background(Color("orange"))
                                            .foregroundColor(.black)
                                            .cornerRadius(4)
                                            .padding([.leading, .trailing], 20)
                                            .padding([.top], 20)
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
    static var event = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    static var eventII = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    
    
    static var eventsInWeek = [[Event]]()
    static var helper  = DateHelper()
    static var eventViewModel = EventsViewModel()
    static var daysArray = [String]()
    static var datesArray = [String]()
    
    static var previews: some View {
        KanbanView(eventViewModel: eventViewModel, daysArray: daysArray, datesArray: datesArray, eventsInWeek: eventsInWeek, helper: helper)
    }
}
