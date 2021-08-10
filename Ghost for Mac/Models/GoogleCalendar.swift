//
//  Calendar.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 15/04/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation

struct GoogleCalendar: Hashable, Identifiable {
    
    var id: String
    var owner: String
    var primary : Bool
    var name : String
    
    init(id: String, owner: String, primary : Bool, name: String) {
        self.id = id
        self.owner = owner
        self.primary = primary
        self.name = name
    }
    
    
}
