//
//  AppDelegate.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 15/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Cocoa
import Preferences
import GAppAuth
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let storeHelper = Store()
    var currentAccount : String = ""
    
    //@EnvironmentObject var eventViewModel = EventsViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        // Handle URL event
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
              
        //GAppAuth.shared.appendAuthorizationRealm(OIDScopeEmail)
        GAppAuth.shared.appendAuthorizationRealm("https://www.googleapis.com/auth/calendar")
        GAppAuth.shared.appendAuthorizationRealm("https://www.googleapis.com/auth/contacts")
        GAppAuth.shared.appendAuthorizationRealm("https://www.googleapis.com/auth/contacts.readonly")
              
        // Retrieve existing auth
        GAppAuth.shared.retrieveExistingAuthorizationState()
    }
    
    func logout() {
        GAppAuth.shared.resetAuthorizationState()
        storeHelper.clearAll()
    }
    
    @objc private func handleEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue ?? ""
        let url = URL(string: urlString)!
        
        _ = GAppAuth.shared.continueAuthorization(with: url, callback: nil)
    }
    
    private lazy var preferences: [PreferencePane] = [
            GeneralPreferenceViewController(),
            AccountsPreferenceViewController()
        ]
    
    private lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: preferences,
        style: .toolbarItems,
        animated: true,
        hidesToolbarForSingleItem: true
    )
    
    func showPreferences(){
        preferencesWindowController.show()
    }
    
    @IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack

    lazy var persistentContainer:  NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container =  NSPersistentCloudKitContainer(name: "Ghost_for_Mac")
        let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        //let localStoreLocation = URL(fileURLWithPath: storeDirectory.appendingPathComponent("/Ghost/local.store"))
        let localStoreDescription = NSPersistentStoreDescription(url: storeDirectory.appendingPathComponent("/Ghost/local.store"))
        localStoreDescription.shouldInferMappingModelAutomatically = true
        localStoreDescription.shouldMigrateStoreAutomatically = true
        localStoreDescription.configuration = "Local"
        
        //let cloudStoreLocation = URL(fileURLWithPath: storeDirectory.appendingPathComponent("/Ghost/cloud.store"))
        let cloudStoreDescription = NSPersistentStoreDescription(url: storeDirectory.appendingPathComponent("/Ghost/cloud.store"))
        cloudStoreDescription.shouldInferMappingModelAutomatically = true
        cloudStoreDescription.shouldMigrateStoreAutomatically = true
        cloudStoreDescription.configuration = "Cloud"
   
        // Set the container options on the cloud store
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.ephod.ghost")
              
        // Update the container's list of store descriptions
        container.persistentStoreDescriptions = [cloudStoreDescription, localStoreDescription]
        
        // turn on persistent history tracking
//        let description = container.persistentStoreDescriptions.first
//        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
//        description?.configuration = "Cloud"
//        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
//        description?.setOption(true as NSNumber, forKey: remoteChangeKey)
//        description?.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.ephod.ghost")
        
        //container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.automaticallyMergesChangesFromParent = false
            //container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error)")
//            }
//        })
//        return container
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

