//
//  LineInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct LineInteractor {
    
    static func search(_ searchQuery: String, direction: BusLine.Direction? = nil,
                       _ retryHelper: OVRetryHelper? = nil,
                       handler: @escaping ListResponseHandler<BusLine>) {
        
        BTNetwork.olhoVivoRequest(BTRequest.searchLine(query: searchQuery, direction: direction))
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    if let lines = BusLine.listFrom(data, { handler(nil, $0) }) {
                        handler(lines, nil)
                    }
                case .failure(let error):
                    handler(nil, error)
                }
        }
    }
    
}
