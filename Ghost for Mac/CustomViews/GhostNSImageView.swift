//
//  GhostNSImageView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 16/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class GhostNSImageView: NSImageView {
    
    
    
    
    init?(frame: NSRect, andImage image: NSImage?) {
        super.init(frame: frame)
        layer = CALayer()
        layer?.backgroundColor = NSColor.gray.cgColor
        layer?.contentsGravity = .resizeAspectFill
        layer?.contents = image
        wantsLayer = true
        print("sucks")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("sucks ii")
    }
    
    
}
