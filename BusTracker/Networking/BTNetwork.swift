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
    
    static func olhoVivoRequest(_ request: URLRequestConvertible, showRetryAlert: Bool = false) -> DataRequest {
        
        let manager = Alamofire.SessionManager.default
        manager.retrier = AuthRetrier()
        
        if showRetryAlert {
            return manager.request(request).validate()
        }
        
        return manager.request(request).validate()
    }
    
}

class AuthRetrier: RequestRetrier {
    
    var retryCount = 0
    public func should(_ manager: SessionManager, retry request: Request,
                       with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse,
        response.statusCode == 401, retryCount == 0 {
            print("log: authenticating...")
            AuthInteractor.authenticate { success in
                if success {
                    print("log: authenticated!")
                    completion(true, 0.0)
                    return
                } else {
                    completion(true, 0.0)
                }
            }
        } else if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 200,
            (error as NSError).code == URLError.userAuthenticationRequired.rawValue {
            
            if retryCount > 2 {
                completion(false, 0.0)
            } else {
                self.retryCount += 1
                print("log: failed to authenticate :(")
                print("log: retrying... count \(self.retryCount)")
                completion(true, 0.5)
            }
            
        } else {
            DispatchQueue.main.async {
                let alert = RetryAlert(nibName: "RetryAlert", bundle: Bundle.main)
                
                alert.closeAlertHandler = { completion(false, 0.0) }
                alert.retryHandler = { completion(true, 0.5) }
                alert.message = error.localizedDescription
                
                alert.show(animated: true)
            }
            completion(false, 0.0)
        }
        
    }
}
