//
//  EventTableCell.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 06/04/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class EventTableCell: NSTableCellView {
    
    @IBOutlet weak var startTimeLabel: NSTextField!
    @IBOutlet weak var endTimeLabel: NSTextField!
    @IBOutlet weak var dividerView: rndBgNSView!
    @IBOutlet weak var eventTypeLabel: NSTextField!
    @IBOutlet weak var eventSummaryLabel: NSTextField!
    
    
    
    let meetingTextColor = NSColor.init(named: "meetingGreen")
       let meetingBgColor = NSColor.init(named: "meetingGreenBg")
       let meetingTagColor = NSColor.init(named: "meetingTag")
       
       let workTextColor = NSColor.init(named: "eventWork")
       let workBgColor = NSColor.init(named: "eventWorkBg")
       let workTagColor = NSColor.init(named: "eventWorkTag")
       
       let taskTextColor = NSColor.init(named: "eventTask")
       let taskBgColor = NSColor.init(named: "eventTaskBg")
       let taskTagColor = NSColor.init(named: "eventTaskTag")
       
       let gymTextColor = NSColor.init(named: "eventGym")
       let gymBgColor = NSColor.init(named: "eventGymBg")
       let gymTagColor = NSColor.init(named: "eventGymTag")
       
       func setColor(eventType: String){
        switch eventType {
        case "#meeting":
            dividerView.backgroundColor = meetingBgColor!
        case "#work":
            dividerView.backgroundColor = workBgColor!
        case "#gym":
            dividerView.backgroundColor = gymBgColor!
        case "#task":
            dividerView.backgroundColor = taskBgColor!
        default:
            break
        }
    }
    
    
}
