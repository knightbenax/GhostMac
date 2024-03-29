//
//  BaseViewModel.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 24/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import AppKit

class BaseViewModel{
    
    let storeHelper = Store()
    let googleService = GoogleService()
    let rescueTimeService = RescueTimeService()
    
    func getDelegate() -> AppDelegate{
        return (NSApplication.shared.delegate) as! AppDelegate
    }
    
    func showPreferences(){
        getDelegate().showPreferences()
    }
    
    func getTimeAndDate(day: Int = 0) -> String{
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let tempCurrentDate = calendar.startOfDay(for: Date())
              
        let startComponents = NSDateComponents()
        startComponents.day = day
        let dateAtMidnight = calendar.date(byAdding: startComponents as DateComponents, to: tempCurrentDate)
              
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en-US")   
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           
        var dateString = ""
        dateString = dateFormatter.string(from: dateAtMidnight!)
        return dateString
    }
    
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
    
    func getDateFromString(dateInString : String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateInString) ?? Date()
        
    }
    
    func getStringFromEventDate(hasTime: Bool, thisDate: Date) -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        if (hasTime){
            dateFormatterPrint.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        } else {
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        }
        
        return dateFormatterPrint.string(from: thisDate)
    }
    
    
    func getDatesForComparisonBool(hasTime: Bool, thisDate: String) -> Date{
        if (hasTime){
            return getSimpleDateFromString(dateInString: thisDate)
        } else {
            return getSimpleDateFromStringNoTime(thisDate: thisDate)
        }
    }
    
    
    func getDatesForComparison(event: Event) -> Date{
        if (event.hasTime){
            return getSimpleDateFromString(dateInString: event.startDate)
        } else {
            return getSimpleDateFromStringNoTime(thisDate: event.startDate)
        }
    }
    
    func getDatesForComparisonEnd(event: Event) -> Date{
        if (event.hasTime){
            return getSimpleDateFromString(dateInString: event.endDate)
        } else {
            return getSimpleDateFromStringNoTime(thisDate: event.endDate)
        }
    }
    
    
    func getSimpleDateFromString(dateInString : String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateInString) ?? Date()
        
    }
    
    
    func getSimpleDateFromStringNoTime(thisDate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: thisDate) ?? Date()
    }
    
    
    func manageError(responseCode: Int){
        print(responseCode)
    }
    
    
}
