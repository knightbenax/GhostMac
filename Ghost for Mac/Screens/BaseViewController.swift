//
//  BaseViewController.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 24/03/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import AppKit

class BaseViewController: NSViewController {
    
    let store = Store()
    let googleService = GoogleService()
    
    
    func getTimeAndDate(diff: Int = 0, day: Int = 0) -> String{
           var calendar = NSCalendar.current
           calendar.timeZone = NSTimeZone.local
           let tempCurrentDate = calendar.startOfDay(for: Date())
           
           let startComponents = NSDateComponents()
           startComponents.day = day
           startComponents.second = diff
           let dateAtMidnight = calendar.date(byAdding: startComponents as DateComponents, to: tempCurrentDate)
           
           let components = NSDateComponents()
           components.day = 1 + day
           components.second = diff
           let dateAtEnd = calendar.date(byAdding: components as DateComponents, to: tempCurrentDate)
            
           
           let dateFormatter = DateFormatter()
           dateFormatter.timeZone = TimeZone.current
           dateFormatter.locale = Locale(identifier: "en-US")
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           
           var dateString = ""
           
           if (diff == 0){
               dateString = dateFormatter.string(from: dateAtMidnight!.addingTimeInterval(TimeInterval(diff)))
           } else {
               dateString = dateFormatter.string(from: dateAtEnd!)
           }
           
           return dateString
       }
       
    
}
