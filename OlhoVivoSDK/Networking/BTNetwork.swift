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

typealias ListResponseHandler<T: Decodable> = ([T]?, Error?) -> Void
typealias ObjectResponseHandler<T: Decodable> = (T?, Error?) -> Void

struct OVRetryHelper {
    
    typealias RetryHelperBlock = (Error) -> (Bool, TimeInterval)
    var retry: RetryHelperBlock
    
    init(_ retry: @escaping RetryHelperBlock) {
        self.retry = retry
    }
}

struct BTNetwork {
    
    static func olhoVivoRequest(_ request: BTRequest, _ retryHelper: OVRetryHelper? = nil) -> DataRequest {
        
        SessionManager.default.startRequestsImmediately = false
        let dataRequest = SessionManager.default.request(request)
        
        AuthRetrier.shared.addCustomHandler(retryHelper, for: dataRequest)
        SessionManager.default.retrier = AuthRetrier.shared
        
        dataRequest.resume()
        dataRequest.validate()
        return dataRequest
    }
    
}

extension Request: Hashable {
    
    public var hashValue: Int {
        return (self.request?.hashValue ?? 0) ^ (self.response?.hashValue ?? 0) ^ self.retryCount.hashValue
    }
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
}

class AuthRetrier: RequestRetrier {
    
    static let shared = AuthRetrier()
    private var retryTable = [Request: OVRetryHelper]()
    
    public func addCustomHandler(_ handler: OVRetryHelper?, for request: Request) {
        if let handler = handler {
            retryTable[request] = handler
        }
    }
    
    public func should(_ manager: SessionManager, retry request: Request,
                       with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let response = request.task?.response as? HTTPURLResponse,
        response.statusCode == 401, request.retryCount == 0 {
            
            // Authentication Challenge
            
            AuthInteractor.authenticate { success in
                if success {
                    completion(true, 0.0)
                    return
                } else {
                    completion(true, 0.0)
                }
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
        
            
            guard let handler = retryTable[request] else {
                completion(false, 0.0)
                return
            }
            
            let result: (retry: Bool, after: TimeInterval) = handler.retry(error)
            completion(result.retry, result.after)
            
        }
        
    }
}
