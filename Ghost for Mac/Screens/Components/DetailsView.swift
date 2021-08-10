//
//  DetailsView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 08/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
    var helper = DateHelper()
    var event : Event
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(event.summary).font(.custom("Overpass-Regular", size: 16))
                    .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                HStack(alignment: .center){
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 16, weight: .bold))
                    Text(helper.formatDateToTimeOnly(event: event)).font(.custom("Overpass-Regular", size: 12))
                        .opacity(0.6)
                }.padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                if (event.location != ""){
                    HStack(alignment: .center){
                        Image(systemName: "map.fill")
                            .font(.system(size: 16, weight: .bold))
                        if (isValidUrl(url: event.location!)){
                            Link(event.location ?? "", destination: URL(string: event.location ?? "")!).font(.custom("Overpass-Regular", size: 12))
                                .opacity(0.6)
                        } else {
                            Text(event.location ?? "").font(.custom("Overpass-Regular", size: 12))
                                .opacity(0.6)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                }
                Spacer()
            }.padding([.leading, .trailing], 14)
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var event = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com")
    
    static var previews: some View {
        DetailsView(event: event)
    }
}