//
//  Store.swift
//  WInSalvo
//
//  Created by Bezaleel Ashefor on 05/03/2019.
//  Copyright © 2019 WinSalvo. All rights reserved.
//

import Foundation
import CoreData
import AppKit

class Store{
    
    let suite = "group.com.ephod.ghost"
    
    func saveUser(delegate: AppDelegate, result: NSDictionary, account : String, color: String){
        let users = getUsers(delegate: delegate)
        var containsAccountAlready = false
        
        for user in users {
            if (user.value(forKey: "name") as! String == account){
                containsAccountAlready = true
            }
            break
        }
        
        //avoid adding a duplicate google account
        if (!containsAccountAlready){
            let managedContext = delegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Account", in: managedContext)
            let call = NSManagedObject(entity: entity!, insertInto: managedContext)
            call.setValue(result.object(forKey: "access_token")! as! String, forKey: "access_token")
            call.setValue(result.object(forKey: "id_token")! as? String, forKey: "id_token")
            call.setValue(result.object(forKey: "refresh_token")! as? String, forKey: "refresh_token")
            call.setValue(result.object(forKey: "expires_in")! as? String, forKey: "expires_in")
            call.setValue(account, forKey: "name")
            call.setValue(color, forKey: "color")
            call.setValue(Date(), forKey: "logged_date")
            call.setValue(true, forKey: "loggedin")
            call.setValue(Date(), forKey: "date_added")
            call.setValue(Date(), forKey: "date_modified")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Couldn't save shit \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    func saveUser(result: NSDictionary){
        let currentDate = Date()
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "access_token")! as! String, forKey: "access_token")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "refresh_token")! as? String, forKey: "refresh_token")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "expires_in")! as? TimeInterval, forKey: "expires_in")
        //UserDefaults(suiteName: "group.com.ephod.ghost")!.set(result.object(forKey: "expires_in")! as? String, forKey: "expires_in")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(currentDate, forKey: "logged_date")
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(true, forKey: "loggedin")
    }
    
    func getCalendars(delegate: AppDelegate) -> [GoogleCalendar]{
        var calendars : [NSManagedObject] = []
        var gCalendars : [GoogleCalendar] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GCalendar")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date_added", ascending: false)]
        
        do {
            try calendars = managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
        
        calendars.forEach({
            gCalendars.append(GoogleCalendar(id: $0.value(forKey: "id") as! String,
                                             owner: $0.value(forKey: "account") as! String,
                                             primary: $0.value(forKey: "primary") as! Bool,
                                             name: $0.value(forKey: "name") as! String))
        })
        
        return gCalendars
    }
    
    func saveCalendars(delegate: AppDelegate, calendars : [GoogleCalendar]){
        let savedCalendars = getSavedCalendars(delegate: delegate)
        
        calendars.forEach({
            var containsCalendarAlready = false
            
            for savedcalendar in savedCalendars {
                if (savedcalendar.value(forKey: "id") as! String == $0.id){
                    containsCalendarAlready = true
                }
            }
            
            if (!containsCalendarAlready){
                let managedContext = delegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "GCalendar", in: managedContext)
                let call = NSManagedObject(entity: entity!, insertInto: managedContext)
                call.setValue($0.owner, forKey: "account")
                call.setValue($0.id, forKey: "id")
                call.setValue($0.primary, forKey: "primary")
                call.setValue($0.name, forKey: "name")
                call.setValue(Date(), forKey: "date_added")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Couldn't save shit \(error), \(error.userInfo)")
                }
            }
        })
    }
    
    
    func getSavedCalendars(delegate: AppDelegate) -> [NSManagedObject]{
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GCalendar")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date_added", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "primary = %d", true)
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
        
        return accounts
    }
    
    func getSingleSavedAccount(name: String, delegate: AppDelegate) -> [NSManagedObject]{
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date_added", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
        
        return accounts
    }
    
    
    func getSingleSavedCalendar(id: String, delegate: AppDelegate) -> [NSManagedObject]{
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GCalendar")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date_added", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "primary = TRUE AND id == %@", id)
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
        
        return accounts
    }
    
    func updateUser(delegate: AppDelegate, result: NSDictionary, account : String){
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "name = '\(account)'")
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
            if (accounts.count > 0){
                let accountToEdit = accounts.first!
                accountToEdit.setValue(result.object(forKey: "access_token")! as! String, forKey: "access_token")
                accountToEdit.setValue(result.object(forKey: "expires_in")! as? String, forKey: "expires_in")
                accountToEdit.setValue(Date(), forKey: "logged_date")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Couldn't save shit \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
    }
    
    
    func updateCalendarName(delegate: AppDelegate, account : String, name : String){
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GCalendar")
        fetchRequest.predicate = NSPredicate(format: "primary = TRUE AND id == %@", account)
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
            if (accounts.count > 0){
                let accountToEdit = accounts.first!
                accountToEdit.setValue(name, forKey: "name")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Couldn't save shit \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
    }
    
    
    func updateUserColor(delegate: AppDelegate, account : String, color : String){
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "name = '\(account)'")
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
            if (accounts.count > 0){
                let accountToEdit = accounts.first!
                accountToEdit.setValue(color, forKey: "color")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Couldn't save shit \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
    }
    
    func setNotification(){
        
        UserDefaults(suiteName: "group.com.ephod.ghost")!.set(true, forKey: "scheduled_notifcation")
    }
    
    func hasSetNotification() -> Bool{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.bool(forKey: "scheduled_notifcation")
    }
    
    func userLoggedIn() -> Bool{
        let delegate = (NSApplication.shared.delegate as! AppDelegate)
        let users = getUsers(delegate: delegate)
        return users.count > 0
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
    
    func getTokenExpired() -> TimeInterval{
        return UserDefaults(suiteName: "group.com.ephod.ghost")!.object(forKey: "expires_in") as! TimeInterval
    }
    
    func getLoggedDate(account: String) -> Date{
        let delegate = (NSApplication.shared.delegate as! AppDelegate)
        let users = getUsers(delegate: delegate)
        let user = users.firstIndex(where: {$0.value(forKey: "name") as! String == account})
        return users[user!].value(forKey: "logged_date") as! Date
        //return UserDefaults(suiteName: "group.com.ephod.ghost")!.object(forKey: "logged_date") as! Date
    }
    
    func getUserToken(account: String) -> String{
        let delegate = (NSApplication.shared.delegate as! AppDelegate)
        let users = getUsers(delegate: delegate)
        let user = users.firstIndex(where: {$0.value(forKey: "name") as! String == account})
        return users[user!].value(forKey: "access_token") as! String
        //return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "access_token")!
    }
    
    func getRefreshToken(account: String) -> String{
        let delegate = (NSApplication.shared.delegate as! AppDelegate)
        let users = getUsers(delegate: delegate)
        let user = users.firstIndex(where: {$0.value(forKey: "name") as! String == account})
        return users[user!].value(forKey: "refresh_token") as! String
        //return UserDefaults(suiteName: "group.com.ephod.ghost")!.string(forKey: "refresh_token")!
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
    
    func getUsers(delegate: AppDelegate) -> [NSManagedObject]{
        var accounts : [NSManagedObject] = []
        
        let managedContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Account")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date_added", ascending: false)]
        
        do {
            try accounts = managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't retrieve shit \(error), \(error.userInfo)")
        }
        
        return accounts
    }
       
}
