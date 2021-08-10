//
//  DateHelper.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 10/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
class DateHelper {
    
    func formatDateToBeauty(thisDate: Date, type: String = "day") -> String{
        switch type {
        case "year":
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "yyyy"
             return dateFormatterPrint.string(from: thisDate)
        case "day":
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "d MMMM"
             return dateFormatterPrint.string(from: thisDate)
        case "month":
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMMM"
            return dateFormatterPrint.string(from: thisDate)
        case "month_year":
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMMM YYYY"
            return dateFormatterPrint.string(from: thisDate)
        default:
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "dd"
             return dateFormatterPrint.string(from: thisDate)
        }
    }
    
    func getDayOfWeek(today: Date) -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: today)
        return weekDay
    }
    
   
    
    func formatDateToTimeOnly(event: Event) -> String{
        if (event.hasTime){
            return getTimeFromDate(thisDate: event.startDate) + " - " +  getTimeFromDate(thisDate: event.endDate)
        } else {
            return "ALL DAY"
        }
    }
    
    func getTimeFromDate(thisDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        //2019-07-08T18:00:00+01:00
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "h:mm a"
        //dateFormatterPrint.dateFormat = "dd MMM YYYY"
        
        let date = dateFormatterGet.date(from: thisDate)
        return dateFormatterPrint.string(from: date!)
    }
    
    func getDayFromDate(thisDate: Date) -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterPrint.dateFormat = "d"
        
        return dateFormatterPrint.string(from: thisDate)
    }
    
    func getTimeFromDateTemp(thisDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        //2019-07-08T18:00:00+01:00
        let dateFormatterPrint = DateFormatter()
        //dateFormatterPrint.dateFormat = "h:mm a"
        dateFormatterPrint.dateFormat = "dd MMM YYYY"
        
        let date = dateFormatterGet.date(from: thisDate)
        return dateFormatterPrint.string(from: date!)
    }
    
    
}
