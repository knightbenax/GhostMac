//
//  EventsInWeek.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 16/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation

class EventsInWeek: ObservableObject{
    
    @Published var weekevents = [[Event]]()
    @Published var currentEvent = Event()
    var lastActiveDate = Date()
    
}
