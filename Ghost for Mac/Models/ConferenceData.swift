//
//  ConferenceData.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 20/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import SwiftUI

class ConferenceData {
    
    var toolName : String
    var toolLink : String
    var toolPhoneLink : String
    
    init(toolName: String, toolLink: String, toolPhoneLink: String) {
        self.toolName = toolName
        self.toolLink = toolLink
        self.toolPhoneLink =  toolPhoneLink
    }
    
    init() {
        self.toolName = ""
        self.toolLink = ""
        self.toolPhoneLink = ""
    }
    
}
