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
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    
    var body: some View {
        HStack(spacing: 0){
            Rectangle()
                .fill(Color(eventViewModel.getCalendarTextBackgroundColor(event: event)))
                .frame(width: 10)
            VStack(alignment: .leading, spacing: 0){
                Text(event.summary).font(.custom("Overpass-Regular", size: 14))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                if (event.hasTime){
                    HStack(spacing: 4){
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text(helper.formatDateToTimeOnly(event: event)).font(.custom("Overpass-Regular", size: 12))
                    }.opacity(0.6)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
                if(event.location != nil && !event.location!.isEmpty){
                    if (!isValidUrl(url: event.location!)){
                        HStack (spacing: 0){
                            HStack(spacing: 4){
                                Image(systemName: "location.fill")
                                    .font(.system(size: 12))
                                Text(event.location!.capitalized).font(.custom("Overpass-Regular", size: 12))
                                    .foregroundColor(Color("ribsTextColor"))
                            }.padding(EdgeInsets(top: 4, leading: 11, bottom: 4, trailing: 11))
                            .background(Color("kanbanInside"))
                            .cornerRadius(20)
                        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                }
//                if(event.conferenceData != nil){
//                    HStack (spacing: 0){
//                        HStack(spacing: 4){
//                            Image(systemName: "video.fill")
//                                .font(.system(size: 12))
//                            Text( event.conferenceData!.toolName).font(.custom("Overpass-Regular", size: 12))
//                                .foregroundColor(Color("ribsTextColor"))
//                        }.padding(EdgeInsets(top: 4, leading: 11, bottom: 4, trailing: 11))
//                        .background(Color("kanbanInside"))
//                        .cornerRadius(20)
//                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//                }
                ConferenceView(event: event)
            }.padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
          )
        .background(Color("darkBgColor"))
        .cornerRadius(5)
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
