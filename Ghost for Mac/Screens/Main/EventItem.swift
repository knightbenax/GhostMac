//
//  EventItem.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 23/03/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Cocoa

class EventItem: NSCollectionViewItem {

    @IBOutlet weak var todayDotView: BgNSView!
    @IBOutlet weak var dayText: NSTextField!
    @IBOutlet weak var dateText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
