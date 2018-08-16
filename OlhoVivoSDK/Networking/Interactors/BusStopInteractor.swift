//
//  BusStopInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 10/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

fileprivate extension DataRequest {
    func busStops(handler: @escaping ListResponseHandler<OVStop>) -> Self {
        self.responseData { response in
            switch response.result {
            case .success(let data):
                if let lines = OVStop.listFrom(data, { handler(nil, $0) }) {
                    handler(lines, nil)
                }
            case .failure(let error):
                handler(nil, error)
            }
        }
        return self
    }
}

internal struct BusStopInteractor {
    
    static func search(_ searchQuery: String, _ retryHelper: RetryHelperBlock? = nil,
                       handler: @escaping ListResponseHandler<OVStop>) {
        _ = OVNetwork.olhoVivoRequest(.stops(by: .search(searchQuery)), retryHelper)
            .busStops(handler: handler)
    }
    
    static func stops(for line: OVLine, _ retryHelper: RetryHelperBlock? = nil,
                      handler: @escaping ListResponseHandler<OVStop>) {
        _ = OVNetwork.olhoVivoRequest(.stops(by: .line(line)), retryHelper)
            .busStops(handler: handler)
    }
    
    static func stops(for corridor: OVCorridor, _ retryHelper: RetryHelperBlock? = nil,
                      handler: @escaping ListResponseHandler<OVStop>) {
        _ = OVNetwork.olhoVivoRequest(.stops(by: .corridor(corridor)), retryHelper)
            .busStops(handler: handler)
    }
}
