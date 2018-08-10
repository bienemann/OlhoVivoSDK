//
//  LineInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct LineInteractor {
    
    typealias LineResponseHandler = ([BusLine]?, Error?) -> Void
    
    static func search(_ searchQuery: String, direction: BusLine.Direction? = nil,
                       handler: @escaping LineResponseHandler) {
        
        BTNetwork.olhoVivoRequest(BTRequest.searchLine(query: searchQuery, direction: direction),
                                  showRetryAlert: true)
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
