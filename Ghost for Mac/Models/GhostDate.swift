//
//  GhostDate.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 02/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import SwiftUI

class GhostDate: Identifiable{
    
    var date: Date?
    
    init(date: Date?) {
        self.date = date
    }
        
}
