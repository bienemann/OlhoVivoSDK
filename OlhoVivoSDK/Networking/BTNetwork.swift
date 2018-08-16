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

struct BTNetwork {
    
    static func olhoVivoRequest(_ request: BTRequest,
                                _ retryHelper: OVRetryHelper? = nil) -> DataRequest {
        
        SessionManager.default.retrier = OVRetrier.shared
        return OVRetrier.shared.addCustomHandler(
            retryHelper,
            for: SessionManager.default.request(request)
        )
    }
    
}

extension Request: Hashable {
    
    public var hashValue: Int {
        guard
            let task = self.task,
            let request = self.request
        else {
                return 0
        }
        
        return self.session.hash ^ task.hash ^ request.hashValue
    }
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
