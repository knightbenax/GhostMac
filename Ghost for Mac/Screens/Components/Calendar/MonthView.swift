//
//  MonthView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 02/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.black)
            .background(configuration.isPressed ? Color.white : Color("orange"))
            .cornerRadius(4.0)
    }
}

struct MonthView: View {
    @State var today = Date()
    @State var dates : [Date] = Date().getAllDays()
    let calendar = Calendar.current
    @State var ghostDates : [GhostDate] = []
    var helper = DateHelper()
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @EnvironmentObject var event : Event
    @ObservedObject var eventViewModel : EventsViewModel
    @ObservedObject var loadingIndicator : LoadingIndicator
    
    init(eventViewModel : EventsViewModel, loadingIndicator: LoadingIndicator) {
        self.loadingIndicator = loadingIndicator
        self.eventViewModel = eventViewModel
    }
    
    func loadDates(){
        dates = today.getAllDays()
        let firstDate = Calendar.current.component(.weekday, from: dates[0])
        
        for _ in 0..<firstDate - 1 {
            let thisGhostDate = GhostDate(date: nil)
            ghostDates.append(thisGhostDate)
        }
        
        dates.forEach({
            let thisGhostDate = GhostDate(date: $0)
            ghostDates.append(thisGhostDate)
        })
        
        
    }
    
    func advanceByMonth(){
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: today)
        today = newDate!
        dates = today.getAllDays()
        self.ghostDates.removeAll()
        let firstDate = Calendar.current.component(.weekday, from: dates[0])
        for _ in 0..<firstDate - 1 {
            let thisGhostDate = GhostDate(date: nil)
            ghostDates.append(thisGhostDate)
        }
        dates.forEach({
            let thisGhostDate = GhostDate(date: $0)
            self.ghostDates.append(thisGhostDate)
        })
    }
    
    func reveserByMonth(){
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: today)
        today = newDate!
        dates = today.getAllDays()
        self.ghostDates.removeAll()
        let firstDate = Calendar.current.component(.weekday, from: dates[0])
        for _ in 0..<firstDate - 1 {
            let thisGhostDate = GhostDate(date: nil)
            ghostDates.append(thisGhostDate)
        }
        dates.forEach({
            let thisGhostDate = GhostDate(date: $0)
            self.ghostDates.append(thisGhostDate)
        })
    }
    
    var sixColumnGrid: [GridItem] = Array(repeating: .init(.fixed(30)), count: 7)
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center){
                Text(helper.formatDateToMonth(thisDate: today))
                    .font(.custom("Overpass-Regular", size: 16))
                Spacer()
                Button(action: {reveserByMonth()}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 30, height: 30, alignment: .center)
                }
                .buttonStyle(BlueButtonStyle())
                .foregroundColor(.black)
                .cornerRadius(4.0)
                Button(action: {advanceByMonth()}) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 30, height: 30, alignment: .center)
                }
                .foregroundColor(.black)
                .buttonStyle(BlueButtonStyle())
                .cornerRadius(4.0)
            }.padding([.bottom], 14)
            .padding([.top], 14)
            .padding([.leading, .trailing], 13)
            HStack(spacing: 0){
                ForEach(daysOfWeek, id: \.self){ day in
                    Text(day)
                        .font(.custom("Overpass-Bold", size: 14))
                        .frame(width: 38, height: 40, alignment: .center)
                }
            }
            LazyVGrid(columns: sixColumnGrid){
                ForEach(ghostDates){ thisDate in
                    if (thisDate.date != nil){
                        if (calendar.isDateInToday(thisDate.date!)){
                            Text(helper.getDayFromDate(thisDate: thisDate.date!))
                                .font(.custom("Overpass-Regular", size: 14))
                                .padding([.bottom], 4)
                                .border(width: 4, edges: [.bottom], color: Color("orange"))
                                .frame(width: 40, height: 32, alignment: .center)
                                
                        } else {
                            Text(helper.getDayFromDate(thisDate: thisDate.date!))
                                .font(.custom("Overpass-Regular", size: 14))
                                .padding([.bottom], 4)
                                .border(width: 4, edges: [.bottom], color: Color("kanbanInside"))
                                .frame(width: 40, height: 32, alignment: .center)
                        }
                    } else {
                        Text("")
                            .font(.custom("Overpass-Regular", size: 14))
                            .padding([.bottom], 4)
                            .border(width: 4, edges: [.bottom], color: Color("kanbanInside"))
                            .frame(width: 40, height: 32, alignment: .center).hidden()
                    }
                }
            }.padding([.bottom], 40)
            Spacer()
            DetailsView(loadingIndicator: loadingIndicator).environmentObject(event)
        }.frame(minWidth: 0, maxWidth: 280)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 14)
        .background(Color("kanbanInside"))
        .border(width: 1, edges: [.trailing], color: Color("kanbanItemBorder")).onAppear(){
            loadDates()
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var loadingIndicator = LoadingIndicator()
    static var currentMonthDates = Date().getAllDays()
    static var ghostDates = [GhostDate]()
    static var eventViewModel = EventsViewModel()
    static var event = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    
    static var previews: some View {
        MonthView(eventViewModel: eventViewModel, loadingIndicator: loadingIndicator).environmentObject(event)
    }
}
