//
//  BTNetwork.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct BTNetwork {
    
    static func retriableRequest(_ request: URLRequestConvertible) -> DataRequest {
        let manager = Alamofire.SessionManager.default
        manager.retrier = RetryHandler()
        return manager.request(request).validate()
    }
    
}

class RetryHandler: RequestRetrier {
    
    public func should(_ manager: SessionManager, retry request: Request,
                       with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            print("log: authenticating...\n")
            AuthInteractor.authenticate { success in
                if success {
                    print("log: authenticated!\n")
                    completion(true, 0.8)
                } else {
                    print("log: failed to authenticate!\n")
                    completion(false, 0.0)
                }
            }
        } else {
            DispatchQueue.main.async {
                
                let alert = RetryAlert(nibName: "RetryAlert", bundle: Bundle.main)
                
                alert.closeAlertHandler = {
                    completion(false, 0.0)
                }
                
                alert.retryHandler = {
                    completion(true, 0.8)
                }
                
                alert.message = error.localizedDescription
                
                alert.show(animated: true)
                
            }
            
        }
        
    }
}
