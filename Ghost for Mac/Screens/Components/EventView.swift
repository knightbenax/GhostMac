//
//  EventView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 31/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct EventView: View {
    var event : Event
    var helper : DateHelper
    var eventViewModel : EventsViewModel
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(event.summary).font(.custom("Overpass-Regular", size: 14))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
            Text(helper.formatDateToTimeOnly(event: event)).font(.custom("Overpass-Regular", size: 12))
                .opacity(0.6)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))
            HStack{
                Text(eventViewModel.getCalendarName(event: event)).font(.custom("Overpass-Regular", size: 12))
                    .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                    .foregroundColor(Color(eventViewModel.getCalendarTextColor(event: event)))
                    .background(Color(eventViewModel.getCalendarTextBackgroundColor(event: event)))
                    .cornerRadius(2)
                Text(event.type.capitalized).font(.custom("Overpass-Regular", size: 12))
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                    .background(Color.blue)
                    .cornerRadius(2)
            }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
          )
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 12, trailing: 10))
        .background(Color("darkBgColor"))
        .cornerRadius(6)
    }
}

struct EventView_Previews: PreviewProvider {
    static var event = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    static var helper  = DateHelper()
    static var eventViewModel = EventsViewModel()
    
    static var previews: some View {
        EventView(event: event, helper: helper, eventViewModel: eventViewModel)
    }
}
