//
//  LineInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

internal struct LineInteractor {
    
    static func search(_ searchQuery: String, direction: OVLine.Direction? = nil,
                       _ retryHelper: RetryHelperBlock? = nil,
                       handler: @escaping ListResponseHandler<OVLine>) {
        
        OVNetwork.olhoVivoRequest(OVRequest.searchLine(query: searchQuery, direction: direction))
            .responseData { (response) in
                switch response.result {
                case .success(let data):
                    if let lines = OVLine.listFrom(data, { handler(nil, $0) }) {
                        handler(lines, nil)
                    }
                case .failure(let error):
                    handler(nil, error)
                }
        }
    }
    
}
