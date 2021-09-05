//
//  ConferenceView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 05/09/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct ConferenceView: View {
    var event : Event
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    func openUrl(url: String){
        if (isValidUrl(url: url)){
            let url = URL(string: url)!
            NSWorkspace.shared.open(url)
        }
    }
    
    var body: some View {
        if(event.conferenceData != nil){
            Button(action: {
                openUrl(url: event.conferenceData?.toolLink ?? "")
            }) {
                HStack(spacing: 4){
                    Image(systemName: "video.fill")
                        .font(.system(size: 12))
                    Text( event.conferenceData!.toolName).font(.custom("Overpass-Regular", size: 12))
                        .foregroundColor(Color("ribsTextColor"))
                }.padding(EdgeInsets(top: 4, leading: 11, bottom: 5, trailing: 11))
                .background(Color("kanbanInside"))
                .cornerRadius(20)
            }.buttonStyle(PlainButtonStyle())
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}

struct ConferenceView_Previews: PreviewProvider {
    static var event = Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com", conferenceData: ConferenceData(toolName: "Skype", toolLink: "https://skype.com/rains", toolPhoneLink: "08027979364"))
    static var previews: some View {
        ConferenceView(event: event)
    }
}
