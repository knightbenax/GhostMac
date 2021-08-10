//
//  RescueTimeService.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 28/10/2019.
//  Copyright © 2019 Ephod. All rights reserved.
//

import Foundation
import Alamofire

class RescueTimeService: BaseClass {
    
    func getProductivityPulse(today: String, completion: @escaping (Result<Any, Error>) -> ()){
        
        let requestURl = AppConstants().rescueTimeURL
        //let rescueTimeKey = AppConstants().rescueTimeKey
        let rescueTimeKey = storeHelper.getRescuetimeKey()!
        
        let parameters: Parameters = [
            "key": rescueTimeKey,
            "resolution_time":"day",
            "restrict_kind":"productivity",
            "perspective":"rank",
            "restrict_begin": today,
            "restrict_end": today,
            "format":"json"
        ]
        
        AF.request(requestURl, method: .get, parameters: parameters)
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
    
}
