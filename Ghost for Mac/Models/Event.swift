//
//  Competition.swift
//  WInSalvo
//
//  Created by Bezaleel Ashefor on 27/03/2019.
//  Copyright © 2019 WinSalvo. All rights reserved.
//

import Foundation

class Event{
    
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
    
    init(id: String, summary: String, startDate: String, endDate: String, colorId: String, type: String, hasTime : Bool, attendees : Array<String>? = nil, markedAsDone: Bool, description: String, location: String? = "") {
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
    }
    
    
}
