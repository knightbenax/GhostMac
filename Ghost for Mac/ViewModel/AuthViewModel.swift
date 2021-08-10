//
//  AuthViewModel.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 24/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import GAppAuth
import SwiftUI

class AuthViewModel : BaseViewModel{
    
//    func doStart(){
//        GAppAuth.shared.retrieveExistingAuthorizationState()
//        checkRegistration()
//    }
    
    func signInGoogle(){
        do {
            try GAppAuth.shared.authorize { auth in
                if auth {
                    self.checkRegistration()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func authorizeNewAccount(){
        do {
            try GAppAuth.shared.authorize { auth in
                if auth {
                    self.addGoogleAccount()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func isLoggedIn() -> Bool{
        return storeHelper.userLoggedIn()
    }
    
    func getRefreshToken(code: String){
        googleService.getGoogleTokens(code: code, completion: { [self](result: Result<Any, Error>) in
            switch (result){
            case .success(let data):
                let data = data as! NSDictionary
                getPrimaryCalendar(resultData: data)
                break
            case .failure(let error):
                print(error)
                break;
            }
        })
    }
    
    func getPrimaryCalendar(resultData: NSDictionary){
        let access_code = resultData.object(forKey: "access_token")! as! String
        googleService.getPrimaryEmailFromCalendarList(token: access_code, completion:  {(result: Result<Any, Error>) in
            switch (result){
            case .success(let data):
                let data = data as! NSDictionary
                print(data)
                let item = data.value(forKey: "id") as! String
                let summary = data.value(forKey: "summary") as! String
                let calendar = GoogleCalendar(id: item, owner: item, primary: true, name: summary)
                var calendars = [GoogleCalendar]()
                calendars.append(calendar)
                self.storeHelper.saveUser(delegate: self.getDelegate(), result: resultData, account: item, color: NSColor.random().toHexString())
                self.storeHelper.saveCalendars(delegate: self.getDelegate(), calendars: calendars)
                break
            case .failure(let error):
                print(error)
                let code = error.asAFError?.responseCode
                self.manageError(responseCode: code!)
                break;
            }
        })
        
    }
    
    
    func checkRegistration(){
        if GAppAuth.shared.isAuthorized() {
//            let authorization = GAppAuth.shared.getCurrentAuthorization()
//            let tokenResponse = authorization?.authState.lastTokenResponse
//            let accessToken : String = (tokenResponse?.accessToken)!
//            let refreshToken : String = (tokenResponse?.refreshToken)!
//            let idToken : String = (tokenResponse?.idToken)!
//            let interval = Date().timeIntervalSince((tokenResponse?.accessTokenExpirationDate)!)
//            let accessExpiryDate : TimeInterval = interval
//            let values : NSMutableDictionary = ["access_token": accessToken,
//                                                "refresh_token": refreshToken,
//                                                "id_token": idToken,
//                                                "expires_in": accessExpiryDate]
//            //storeHelper.saveUser(result: values)
//            getPrimaryCalendar(resultData: values)
            addGoogleAccount()
        }
    }
    
    
    func addGoogleAccount(){
        let authorization = GAppAuth.shared.getCurrentAuthorization()
        let tokenResponse = authorization?.authState.lastTokenResponse
        let accessToken : String = (tokenResponse?.accessToken)!
        let refreshToken : String = (tokenResponse?.refreshToken)!
        let idToken : String = (tokenResponse?.idToken)!
        let interval = Date().timeIntervalSince((tokenResponse?.accessTokenExpirationDate)!)
        let accessExpiryDate : TimeInterval = interval
        let values : NSMutableDictionary = ["access_token": accessToken,
                                            "refresh_token": refreshToken,
                                            "id_token": idToken,
                                            "expires_in": accessExpiryDate]
        getPrimaryCalendar(resultData: values)
    }
    
    
    func getGoogleAccounts() -> [GoogleCalendar]{
        //let accounts = storeHelper.getUsers(delegate: getDelegate())
        let accounts = storeHelper.getSavedCalendars(delegate: getDelegate())
        var googleCalendars = [GoogleCalendar]()
        
        accounts.forEach({
            let id = $0.value(forKey: "id") as! String
            let name = $0.value(forKey: "name") as! String
            let account = $0.value(forKey: "account") as! String
            let primary = $0.value(forKey: "primary") as! Bool
            
            let calendar = GoogleCalendar(id: id, owner: account, primary: primary, name: name)
            googleCalendars.append(calendar)
        })
        
        return googleCalendars
    }
    
    func getSingleAccountName(accountIDToEdit : String) -> String{
        return storeHelper.getSingleSavedCalendar(id: accountIDToEdit, delegate: getDelegate())[0].value(forKey: "name") as! String
    }
    
    func getSingleAccountColor(accountIDToEdit : String) -> String{
        return storeHelper.getSingleSavedAccount(name: accountIDToEdit, delegate: getDelegate())[0].value(forKey: "color") as! String
    }
    
    
    func saveCalendar(accountIDtoEdit: String, accountName: String, accountColor : Color){
        storeHelper.updateCalendarName(delegate: getDelegate(), account: accountIDtoEdit, name: accountName )
        storeHelper.updateUserColor(delegate: getDelegate(), account: accountIDtoEdit, color: NSColor(accountColor).toHexString())
    }
}
