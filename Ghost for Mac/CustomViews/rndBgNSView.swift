//
//  rndBgNSView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 06/04/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class rndBgNSView: BgNSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        roundCorner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        roundCorner()
    }
    
    private func roundCorner(){
        self.wantsLayer = true
        self.layer?.cornerRadius = 3
    }
}
