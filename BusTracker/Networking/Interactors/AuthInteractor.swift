//
//  AuthInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

struct AuthInteractor {
    
    typealias AuthenticationHandler = (Bool) -> Void

    static func authenticate(_ completionHandler: @escaping AuthenticationHandler) {
        
        Alamofire.request(BTRequest.authenticate).responseData { response in
            
            switch response.result {
            case .success:
                guard
                    let data = response.result.value,
                    let responseString = String(data: data, encoding: .utf8), responseString == "true"
                    else {
                        completionHandler(false)
                        return
                }
                completionHandler(true)
                return
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        }
    }
    
}
