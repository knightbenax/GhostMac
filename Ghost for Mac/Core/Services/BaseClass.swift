//
//  BaseClass.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 06/04/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Foundation
import Alamofire

class BaseClass{
    
    let baseUrl = AppConstants().debugBaseUrl
    let storeHelper = Store()
    
    public func nsdataToJSON(data: NSData) -> AnyObject? {
           do {
               return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
           } catch let Error {
               print(Error.asAFError as Any)
           }
           
           return nil
    }
    
    
    func getToken(completion: @escaping (Result<Any, Error>) -> ()){
        var token = ""
        let interval = Date().timeIntervalSince(storeHelper.getTokenExpired())
        if (interval <= 3600){
            token = storeHelper.getUserToken()
            completion(.success(token))
        } else {
            refreshToken(completion: {(result : Result<Any, Error>) in
                switch (result){
                    case .success( _):
                        token = self.storeHelper.getUserToken()
                        completion(.success(token))
                        break
                    case .failure(let error):
                        
                        completion(.failure(error))
                        break
                }
            })
        }
    }
    
    
    func refreshToken(completion: @escaping (Result<Any, Error>) -> ()){
           
        let requestURl = AppConstants().google_authorization_url
        let client_secret = (Bundle.main.object(forInfoDictionaryKey: "GAppAuth") as? NSDictionary)?.object(forKey: "ClientSecret") as! String
           
        print(client_secret)
        let parameters: Parameters = [
            "refresh_token": storeHelper.getRefreshToken(),
            "client_secret" : client_secret,
            "client_id" : AppConstants().google_oauth_client_id,
            "grant_type": "refresh_token"
        ]
           
           AF.request(requestURl, method: .post, parameters: parameters)
               .validate(statusCode: 200..<300).responseJSON(completionHandler: {(response) in
                   switch response.result {
                   case .success(let data):
                       let data = data as! NSDictionary
                       self.storeHelper.updateUser(result: data)
                       print(data)
                       _ = self.nsdataToJSON(data: response.data! as NSData) as? NSDictionary
                       //print(error as Any)
                       completion(.success(data))
                       break
                   case .failure(let serverError):
                    print(serverError)
                       self.addressErrorCode(code: response.response!.statusCode)
                       _ = self.nsdataToJSON(data: response.data! as NSData) as? NSDictionary
                       //print(error as Any)
                       completion(.failure(serverError))
                       break
                   }
               })
           
       }
    
    
    func addressErrorCode(code : Int){
        switch code {
        case 400:
            //logouthere
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.logout()
            break
        default:
            break
        }
    }
       
    
}
