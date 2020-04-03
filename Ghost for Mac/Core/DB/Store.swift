//
//  Store.swift
//  WInSalvo
//
//  Created by Bezaleel Ashefor on 05/03/2019.
//  Copyright © 2019 WinSalvo. All rights reserved.
//

import Foundation


class Store{
    
    func saveUser(result: NSDictionary){
        let currentDate = Date()
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "access_token")! as! String, forKey: "access_token")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "id_token")! as? String, forKey: "id_token")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "refresh_token")! as? String, forKey: "refresh_token")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "expires_in")! as? String, forKey: "expires_in")
        //UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "expires_in")! as? String, forKey: "expires_in")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(currentDate, forKey: "logged_date")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(true, forKey: "loggedin")
    }
    
    func updateUser(result: NSDictionary){
        let currentDate = Date()
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "access_token")! as! String, forKey: "access_token")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "expires_in")! as? String, forKey: "expires_in")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(currentDate, forKey: "logged_date")
    }
    
    func setNotification(){
        
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(true, forKey: "scheduled_notifcation")
    }
    
    func hasSetNotification() -> Bool{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.bool(forKey: "scheduled_notifcation")
    }
    
    func userLoggedIn() -> Bool{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.bool(forKey: "loggedin")
    }
    
    func getUserFullname() -> String{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "userName")!
    }
    
    func getLoggedDate() -> Date{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.object(forKey: "logged_date") as! Date
    }
    
    func getUserEmail() -> String{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "userEmail")!
    }
    
    func getUserToken() -> String{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "access_token")!
    }
    
    func getRefreshToken() -> String{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "refresh_token")!
    }
    
    func clearAll(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults(suiteName: "group.com.ephod.ghost")!.removePersistentDomain(forName: domain)
        UserDefaults(suiteName: "group.com.ephod.ghost")!.synchronize()
    }
    
     func getUrgentCalendar() -> String?{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "urgent_calendar")
     }
    
    func getNickname() -> String?{
       return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "nickname")
    }
    
    func getFirstname() -> String?{
       return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "firstname")
    }
    
    func getRescuetimeKey() -> String?{
       return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "rescuetime")
    }
    
    
    func setUrgentCalendar(calendar: String){
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(calendar, forKey: "urgent_calendar")
    }
    
    
    func setNickname(nickname: String){
           UserDefaults(suiteName: "group.com.ephod.ghost")!.set(nickname, forKey: "nickname")
    }
    
    func setFirstname(firstname: String){
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(firstname, forKey: "firstname")
     }
    
    func setRescuetimeKey(rescuetimekey: String){
       UserDefaults(suiteName: "group.com.ephod.ghost")!.set(rescuetimekey, forKey: "rescuetime")
    }
       
}
