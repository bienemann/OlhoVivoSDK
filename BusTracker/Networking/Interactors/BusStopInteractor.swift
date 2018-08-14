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
    
    static func search(_ searchQuery: String, handler: @escaping ListResponseHandler<BusStop>) {
        _ = BTNetwork.olhoVivoRequest(.stops(by: .search(searchQuery)), showRetryAlert: true)
            .busStops(handler: handler)
    }
    
    static func stops(for line: BusLine, handler: @escaping ListResponseHandler<BusStop>) {
        _ = BTNetwork.olhoVivoRequest(.stops(by: .line(line)), showRetryAlert: true)
            .busStops(handler: handler)
    }
    
    static func stops(for corridor: Corridor, handler: @escaping ListResponseHandler<BusStop>) {
        _ = BTNetwork.olhoVivoRequest(.stops(by: .corridor(corridor)),
                                      showRetryAlert: true)
            .busStops(handler: handler)
    }
}
