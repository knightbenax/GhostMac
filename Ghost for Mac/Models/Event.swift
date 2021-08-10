//
//  Competition.swift
//  WInSalvo
//
//  Created by Bezaleel Ashefor on 27/03/2019.
//  Copyright © 2019 WinSalvo. All rights reserved.
//

import Foundation

import SwiftUI

class Event: Identifiable{
    
    var summary: String
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
    
    init(id: String, summary: String, startDate: String, endDate: String, colorId: String, type: String, hasTime : Bool, attendees : Array<String>? = nil, markedAsDone: Bool, description: String, location: String? = "", account : String) {
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
    }
    
    
}

#if DEBUG
let testData = [
    Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T04:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com"),
    Event(id: "23274264256", summary: "Bless Derin", startDate: "2012-07-19T02:30:00-06:00", endDate: "2012-07-21T12:30:00-06:00", colorId: "#546513", type: "workout", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Lekki", account: "knightbenax@gmail.com"),
    Event(id: "23274264234", summary: "Wound David", startDate: "2012-07-11T02:30:00-06:00", endDate: "2012-07-11T07:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Egbeda", account: "knightbenax@gmail.com"),
    Event(id: "23274264256", summary: "Bless Derin", startDate: "2012-07-19T02:30:00-06:00", endDate: "2012-07-21T02:30:00-06:00", colorId: "#546513", type: "meeting", hasTime: true, attendees: [], markedAsDone: false, description: "Break his back door", location: "Lekki", account: "knightbenax@gmail.com")
]
#endif
