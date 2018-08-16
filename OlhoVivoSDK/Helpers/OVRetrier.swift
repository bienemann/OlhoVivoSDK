//
//  OVRetrier.swift
//  OlhoVivoSDK
//
//  Created by Allan Martins on 16/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

public typealias RetryHelperBlock = (Error) -> (Bool, TimeInterval)

class OVRetrier: RequestRetrier {
    
    static let shared = OVRetrier()
    private var retryTable = RetrierTable<Request, RetryHelperBlock>()
    
    func addCustomHandler(_ handler: RetryHelperBlock?, for request: DataRequest) -> DataRequest {
        if let handler = handler {
            retryTable[request] = handler
        }
        return request
    }
    
    public func should(_ manager: SessionManager, retry request: Request,
                       with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401, request.retryCount == 0 {
            
            // Authentication Challenge
            
            AuthInteractor.shared.authenticate { success in
                completion(true, 0.0)
            }
            
        } else if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 200,
            (error as NSError).code == URLError.userAuthenticationRequired.rawValue {
            
            // Authentication failed
            // Retry 3 times
            
            if request.retryCount > 2 {
                completion(false, 0.0)
            } else {
                completion(true, 0.5)
            }
            
        } else {
            
            if retryTable[request] == nil {
                print("stop here")
            }
            
            guard let handler = retryTable[request] else {
                completion(false, 0.0)
                return
            }
            
            let result: (retry: Bool, after: TimeInterval) = handler(error)
            if result.retry {
                completion(true, result.after)
            } else {
                retryTable[request] = nil
                completion(false, result.after)
            }
            
        }
    }
}
