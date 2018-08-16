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
    func busStops(handler: @escaping ListResponseHandler<BusStop>) -> Self {
        self.responseData { response in
            switch response.result {
            case .success(let data):
                if let lines = BusStop.listFrom(data, { handler(nil, $0) }) {
                    handler(lines, nil)
                }
            case .failure(let error):
                handler(nil, error)
            }
        }
        return self
    }
}

struct BusStopInteractor {
    
    static func search(_ searchQuery: String, _ retryHelper: OVRetryHelper? = nil,
                       handler: @escaping ListResponseHandler<BusStop>) {
        _ = BTNetwork.olhoVivoRequest(.stops(by: .search(searchQuery)), retryHelper)
            .busStops(handler: handler)
    }
    
    static func stops(for line: BusLine, _ retryHelper: OVRetryHelper? = nil,
                      handler: @escaping ListResponseHandler<BusStop>) {
        _ = BTNetwork.olhoVivoRequest(.stops(by: .line(line)), retryHelper)
            .busStops(handler: handler)
    }
    
    static func stops(for corridor: Corridor, _ retryHelper: OVRetryHelper? = nil,
                      handler: @escaping ListResponseHandler<BusStop>) {
        _ = BTNetwork.olhoVivoRequest(.stops(by: .corridor(corridor)), retryHelper)
            .busStops(handler: handler)
    }
}
