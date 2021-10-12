//
//  Competition.swift
//  WInSalvo
//
//  Created by Bezaleel Ashefor on 27/03/2019.
//  Copyright © 2019 WinSalvo. All rights reserved.
//

import Foundation

import SwiftUI

enum EventType{
    case EVENT
    case TASK
}

class Event: Identifiable, ObservableObject{
    
    @Published var summary: String
    var startDate: String
    var endDate: String
    var type: String
    var colorId: String
    var hasTime : Bool
    var id: String
    var attendees : Array<String>?
    var markedAsDone : Bool
    var description : String
    var location : String?
    var account : String?
    var conferenceData : ConferenceData?
    var eventType : EventType?
    
    init() {
        self.summary = ""
        self.startDate = ""
        self.endDate = ""
        self.type = ""
        self.hasTime = false
        self.colorId = ""
        self.id = ""
        self.attendees = nil
        self.markedAsDone = false
        self.description = ""
        self.location = ""
        self.account = ""
        self.conferenceData = nil
        self.eventType = nil
    }
    
    init(id: String, summary: String, startDate: String, endDate: String, colorId: String, type: String, hasTime : Bool, attendees : Array<String>? = nil, markedAsDone: Bool, description: String, location: String? = "", account : String, conferenceData : ConferenceData? = nil, eventType : EventType? = nil) {
        self.summary = summary
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.hasTime = hasTime
        self.colorId = colorId
        self.id = id
        self.attendees = attendees
        self.markedAsDone = markedAsDone
        self.description = description
        self.location = location
        self.account = account
        self.conferenceData = conferenceData
        self.eventType = eventType
    }
    
//    func updateValue(id: String, summary: String, startDate: String, endDate: String, colorId: String, type: String, hasTime : Bool, attendees : Array<String>? = nil, markedAsDone: Bool, description: String, location: String? = "", account : String, conferenceData : ConferenceData? = nil){
//        self.summary = summary
//        self.startDate = startDate
//        self.endDate = endDate
//        self.type = type
//        self.hasTime = hasTime
//        self.colorId = colorId
//        self.id = id
//        self.attendees = attendees
//        self.markedAsDone = markedAsDone
//        self.description = description
//        self.location = location
//        self.account = account
//        self.conferenceData = conferenceData
//    }
//
    
}

#if DEBUG
let testData = [
    Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com"),
    Event(id: "23274264256", summary: "Bless Derin", startDate: "2012-07-19T02:30:00-06:00", endDate: "2012-07-21T12:30:00-06:00", colorId: "#546513", type: "workout", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Lekki", account: "knightbenax@gmail.com"),
    Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T07:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com"),
    Event(id: "23274264256", summary: "Bless Derin", startDate: "2012-07-19T02:30:00-06:00", endDate: "2012-07-21T02:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Lekki", account: "knightbenax@gmail.com")
]
#endif
