//
//  GoogleService.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 13/06/2019.
//  Copyright © 2019 Ephod. All rights reserved.
//

import Foundation
import Alamofire

class GoogleService: BaseClass {
    
    func getGoogleTokens(code: String, completion: @escaping (Result<Any, Error>) -> ()){
        
        let requestURl = AppConstants().google_authorization_url
        
        let parameters: Parameters = [
            "code": code,
            "client_id": AppConstants().google_oauth_client_id,
            "grant_type" : "authorization_code",
            "redirect_uri": "com.ephod.Ghost:/oauth2redirect"
        ]
        
        AF.request(requestURl, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300).responseJSON(completionHandler: {(response) in
                switch response.result {
                case .success(let data):
                    
                    completion(.success(data))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            })
    }
    

    func getGoogleCalendarEvents(calendar_id: String, startDate: String, endDate : String, completion: @escaping (Result<Any, Error>) -> ()){
        
        let requestURl = AppConstants().google_calender + calendar_id + "/events?orderBy=startTime&singleEvents=true&key=" + AppConstants().google_calendar_api_key
        
        getToken(completion: {(result: Result<Any, Error>) in
            
            switch (result){
            case .success(let data):
                let token = data as! String
               
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token,
                    "Accept" : "application/json"
                ]
                
                let parameters: Parameters = [
                    "timeMin": endDate,
                    "timeMax": startDate,
                ]
                
                AF.request(requestURl, method: .get, parameters: parameters, headers: headers)
                    .validate(statusCode: 200..<300).responseJSON(completionHandler: {(response) in
                        switch response.result {
                        case .success(let data):
                            completion(.success(data))
                            break
                        case .failure(let error):
                            let data = self.nsdataToJSON(data: response.data! as NSData) as? NSDictionary
                            print(data as Any)
                            completion(.failure(error))
                            break
                        }
                    })
            case .failure(let error):
                completion(.failure(error))
            }
            
            
        })
        //print(request)
    }
    
    func getColors(completion: @escaping(Result<Any, Error>) -> ()){
        let colorsURl = "https://www.googleapis.com/calendar/v3/colors?key=" + AppConstants().google_calendar_api_key
        //
        
        getToken(completion: {(result: Result<Any, Error>) in
            
            switch (result){
            case .success(let data):
                let token = data as! String
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token,
                    "Accept" : "application/json"
                ]
                
                AF.request(colorsURl, method: .get, headers: headers)
                    .validate(statusCode: 200..<300).responseJSON(completionHandler: {(response) in
                        switch response.result {
                        case .success(let data):
                            completion(.success((data as! NSDictionary).object(forKey: "calendar")!))
                            break
                        case .failure(let error):
                            let data = self.nsdataToJSON(data: response.data! as NSData) as? NSDictionary
                            print(data as Any)
                            completion(.failure(error))
                            break
                        }
                    })
            case .failure(let error):
                completion(.failure(error))
            }
            
            
        })
    }
    
    //https://www.googleapis.com/calendar/v3/calendars/calendarId/events/eventId
     func getContacts(completion: @escaping (Result<Any, Error>) -> ()){
    //       let requestURl = AppConstants().google_people + "&key=" + AppConstants().google_calendar_api_key
            let requestURl = AppConstants().google_people + "?pageSize=900&requestMask.includeField=person.names%2Cperson.email_addresses%2Cperson.photos&sortOrder=FIRST_NAME_ASCENDING&key=" + AppConstants().google_calendar_api_key
            //
            
            getToken(completion: {(result: Result<Any, Error>) in
                
                switch (result){
                case .success(let data):
                    let token = data as! String
                    
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer " + token,
                        "Accept" : "application/json"
                    ]
                    
                    AF.request(requestURl, method: .get, headers: headers)
                        .validate(statusCode: 200..<300).responseJSON(completionHandler: {(response) in
                            switch response.result {
                            case .success(let data):
                                completion(.success(data))
                                break
                            case .failure(let error):
                                let data = self.nsdataToJSON(data: response.data! as NSData) as? NSDictionary
                                print(data as Any)
                                completion(.failure(error))
                                break
                            }
                        })
                case .failure(let error):
                    completion(.failure(error))
                }
                
                
            })
            
        }
    
    
    func getPrimaryEmailFromCalendarList(token : String, completion: @escaping (Result<Any, Error>) -> ()){
        
        //let requestURl = AppConstants().google_calender_list + "?key=" + AppConstants().google_calendar_api_key
        let requestURl = "https://www.googleapis.com/calendar/v3/calendars/primary?key=" + AppConstants().google_calendar_api_key
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept" : "application/json"
        ]
    
        AF.request(requestURl, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300).responseJSON(completionHandler: {(response) in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    break
                case .failure(let error):
                    print(error)
                    let data = self.nsdataToJSON(data: response.data! as NSData) as? NSDictionary
                    print(data as Any)
                    completion(.failure(error))
                    break
                }
            })
    }
    
}
