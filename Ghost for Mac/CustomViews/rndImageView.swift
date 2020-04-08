//
//  rndImageView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 08/04/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class rndImageView: NSImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 3
    
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
        self.layer?.cornerRadius = cornerRadius
    }
}
