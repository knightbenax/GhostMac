//
//  BgNSView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 23/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class BgNSView : NSView{
    
    @IBInspectable var backgroundColor: NSColor = .clear
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor.set()
        dirtyRect.fill()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }

    required init?(coder: NSCoder) {
         super.init(coder: coder)
    }

    //or customized constructor/ init
    init(frame frameRect: NSRect, otherInfo:Int) {
        super.init(frame:frameRect);
        self.wantsLayer = true
        
    }
    
}
