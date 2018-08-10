//
//  BusStopInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 10/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct BusStopInteractor {
    
    static func search(_ searchQuery: String, handler: @escaping ListResponseHandler) {
        
        BTNetwork.olhoVivoRequest(.stops(by: .search(searchQuery)), showRetryAlert: true)
            .responseData { (response) in
                
                switch response.result {
                case .success(let data):
                    if let lines = BusStop.listFrom(data, { handler(nil, $0) }) {
                        handler(lines, nil)
                    }
                case .failure(let error):
                    handler(nil, error)
                }
        }
    }
    
}
