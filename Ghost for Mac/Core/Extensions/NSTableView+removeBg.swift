//
//  NSTableView+removeBg.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 27/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import AppKit

extension NSTableView {
    
  open override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    backgroundColor = NSColor.clear
    enclosingScrollView!.drawsBackground = false
  }
}
