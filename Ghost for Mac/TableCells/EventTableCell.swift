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
    @IBOutlet weak var parentView: rndBgNSView!
    
    
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
        
        //parentView.backgroundColor = NSColor.init(named: "eventHintColor")!
        switch eventType {
        case "#meeting":
            parentView.backgroundColor = meetingBgColor!
        case "#work":
            parentView.backgroundColor = workBgColor!
        case "#gym":
            parentView.backgroundColor = gymBgColor!
        case "#task":
            parentView.backgroundColor = taskBgColor!
        default:
            break
        }
    }
    
    
    
}
