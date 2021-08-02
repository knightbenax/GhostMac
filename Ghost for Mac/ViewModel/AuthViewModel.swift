//
//  AuthViewModel.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 24/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import GAppAuth

class AuthViewModel : BaseViewModel{
    
    func doStart(){
        GAppAuth.shared.retrieveExistingAuthorizationState()
        checkRegistration()
    }
    
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
                //self.manageError(responseCode: code!)
                break;
            }
        })
        
    }
    
    
    func checkRegistration(){
        if GAppAuth.shared.isAuthorized() {
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
            //storeHelper.saveUser(result: values)
            getPrimaryCalendar(resultData: values)
        }
    }
    
}
