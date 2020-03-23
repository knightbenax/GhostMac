//
//  MainWindowViewController.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 23/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class MainWindowViewController: NSWindowController {
    
    @IBOutlet weak var mainWindow: NSWindow!
    
    override func windowWillLoad() {
        mainWindow.titleVisibility = .hidden
        mainWindow.isMovableByWindowBackground = true
    }
}
