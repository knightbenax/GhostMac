//
//  MonthView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 02/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct MonthView: View {
    @State var dates : [Date] = Date().getAllDays()
    var today = Date()
    let calendar = Calendar.current
    var ghostDates : [GhostDate] = []
    var helper = DateHelper()
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @EnvironmentObject var event : Event
    @ObservedObject var eventViewModel : EventsViewModel
    @ObservedObject var loadingIndicator : LoadingIndicator
    
    init(eventViewModel : EventsViewModel, loadingIndicator: LoadingIndicator) {
        self.loadingIndicator = loadingIndicator
        self.eventViewModel = eventViewModel
        
        dates.forEach({
            let thisGhostDate = GhostDate(date: $0)
            ghostDates.append(thisGhostDate)
        })
    }
    
    var sixColumnGrid: [GridItem] = Array(repeating: .init(.fixed(30)), count: 7)
    
    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center){
                Text("August 2021")
                    .font(.custom("Overpass-Bold", size: 18))
                Spacer()
                Button(action: {print("balls")}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                }
                .padding([.leading, .trailing], 8)
                .padding([.bottom, .top], 4)
                .buttonStyle(PlainButtonStyle())
                .background(Color("orange"))
                .foregroundColor(.black)
                .cornerRadius(4)
                Button(action: {print("balls")}) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                }
                .padding([.leading, .trailing], 8)
                .padding([.bottom, .top], 4)
                .buttonStyle(PlainButtonStyle())
                .background(Color("orange"))
                .foregroundColor(.black)
                .cornerRadius(4)
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
                    if (calendar.isDateInToday(thisDate.date)){
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(Color("orange")).frame(width: 30, height: 30)
                            Text(helper.getDayFromDate(thisDate: thisDate.date))
                                .font(.custom("Overpass-Regular", size: 14))
                                .foregroundColor(.white)
                        }.frame(width: 50, height: 40, alignment: .center)
                    } else {
                        Text(helper.getDayFromDate(thisDate: thisDate.date))
                            .font(.custom("Overpass-Regular", size: 14))
                            .frame(width: 50, height: 40, alignment: .center)
                    }
                }
            }.padding([.bottom], 40)
            Spacer()
            DetailsView(loadingIndicator: loadingIndicator).environmentObject(event)
        }.frame(minWidth: 0, maxWidth: 280)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 14)
        .background(Color("kanbanInside"))
        .border(width: 1, edges: [.trailing], color: Color("kanbanItemBorder"))
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
