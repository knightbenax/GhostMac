//
//  Backlog.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 24/09/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation

class Backlog: Identifiable{
    
    var summary : String
    var description : String
    var dateAdded: Date
    var whereAdded : String
    
    init(summary: String, description: String, dateAdded: Date, whereAdded: String) {
        self.summary = summary
        self.description = description
        self.dateAdded = dateAdded
        self.whereAdded = whereAdded
    }
    
}
