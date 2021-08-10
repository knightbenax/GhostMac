//
//  StatsViewModel.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 05/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation


class StatsViewModel: BaseViewModel {
    
    let bad_words = ["Terrible!", "Are you okay?", "What's going on?", "This ain't it chief!", "Do better!", "Fuck you!"]
    let middle_words = ["Not bad", "Fair enough", "You are getting there", "Motivate yourself"]
    let good_words = ["Awesome!", "Nailed it!", "Your dreams would be so proud!", "You are the man!", "Noice!", "This is the shit chief!", "Fuck Yeah!"]
    
    let group = DispatchGroup()
    var thisStat = "Rx + Ment"
    
    func getRescueTimeData(completion: @escaping (_ productivityStat : String) -> ()){
       
        //The user must have a key before we ping RescueTime.
        if let rescueTime = storeHelper.getRescuetimeKey() {
            if (rescueTime != ""){
                group.enter()
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = Locale(identifier: "en-US")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDateString = dateFormatter.string(from: today)
                rescueTimeService.getProductivityPulse(today: todayDateString, completion: { [self](result: Result<Any, Error>) in
                    switch (result){
                    case .success(let data):
                        //Because the data returned is that of a graph. So we would fetch only objects from the row axis
                        let data = (data as! NSDictionary).object(forKey: "rows") as! NSArray
                        thisStat = self.formatPulse(pulseData: data)
                        group.leave()
                        break
                    case .failure(let error):
                        let code = error.asAFError?.responseCode
                        thisStat = "Failed"
                        self.manageError(responseCode: code!)
                        group.leave()
                        break
                   
                    }
               })
            } else {
                thisStat = noRescueTimeData()
            }
        } else {
            thisStat = noRescueTimeData()
        }
        
        group.notify(queue: DispatchQueue.main) { [self] in
            completion(thisStat)
        }
    }
    
    
    func formatPulse(pulseData: NSArray) -> String{
        
        var timeSpent = 0
        var productiveTime = 0
        var pulse = 0
        var pulseText = "Rx"
        
        if (pulseData.count > 0){
            for data in pulseData {
                        let data = data as! NSArray
                        timeSpent = timeSpent + (data[1] as! Int)
                        
                        if ((data[3] as! Int) >= 1){
                            productiveTime = productiveTime + (data[1] as! Int)
                        }
                    }
                    
                    let percentage = Double(productiveTime) / Double(timeSpent)
                    pulse = Int(percentage * 100)
                    
                    if (pulse < 65){
                        let appendage : Int = Int(arc4random_uniform(UInt32(bad_words.count)))
                        pulseText =  "You have been " + String(describing: pulse) + "% productive today. " + bad_words[appendage]
                    } else if (pulse >= 65 && pulse < 70){
                        let appendage : Int = Int(arc4random_uniform(UInt32(middle_words.count)))
                        pulseText =  "You have been " + String(describing: pulse) + "% productive today. " + middle_words[appendage]
                    } else if (pulse >= 70  && pulse < 85){
                        let appendage : Int = Int(arc4random_uniform(UInt32(middle_words.count)))
                        pulseText = "You have been " + String(describing: pulse) + "% productive today. " + middle_words[appendage]
                    } else if (pulse >= 85){
                        let appendage : Int = Int(arc4random_uniform(UInt32(middle_words.count)))
                        pulseText = "You have been " + String(describing: pulse) + "% productive today. " + good_words[appendage]
                    }
        } else {
            pulseText = "You haven't done anything today. Get to work!"
        }
        
        return pulseText
    }
    
    
    func noRescueTimeData() -> String{
        let today = Date()
        var pulseText = "Rx"
         
        let dateFormatter = DateFormatter()
         dateFormatter.timeZone = TimeZone.current
         dateFormatter.locale = Locale(identifier: "en-US")
         dateFormatter.dateFormat = "HH"
         let todayDateString = (Int) (dateFormatter.string(from: today))!
        if (todayDateString >= 0 && todayDateString < 12){
            pulseText = "Good morning. Have a great day!"
        } else if (todayDateString >= 12 && todayDateString < 17){
            pulseText = "Good afternoon. Hope you are having a great day!"
        } else if (todayDateString >= 17 && todayDateString <= 23){
            pulseText = "Good evening. Hope your day went well?"
        }
        
        return pulseText
    }
    
    
    
    
}
