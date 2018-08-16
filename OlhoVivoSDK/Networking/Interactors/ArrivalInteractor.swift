//
//  ArrivalInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

internal struct ArrivalInteractor {
    
    static func nextArrivals(of line: OVLine?,
                             at stop: OVStop,
                             _ retryHelper: RetryHelperBlock? = nil,
                             handler: @escaping ListResponseHandler<OVPosition>) {
        
        _ = OVNetwork.olhoVivoRequest(.arrivals(of: line, at: stop), retryHelper)
        .responseData { response in
            
            switch response.result {
            case .success(let data):
                if let wrapper = ArrivalWrapper_Specific.objectFrom(data, { handler(nil, $0) }) {
                    let positions = wrapper.stop.lines?.map { $0.positionList }.flatMap { $0 }
                    handler(positions, nil)
                }
            case .failure(let error):
                handler(nil, error)
            }
        }
    }
    
    static func nextArrivals(of line: OVLine, _ retryHelper: RetryHelperBlock? = nil,
                             handler: @escaping ListResponseHandler<OVStop>) {
        
        _ = OVNetwork.olhoVivoRequest(.arrivals(of: line, at: nil), retryHelper)
            .responseData { response in
                
                switch response.result {
                case .success(let data):
                    if let wrapper = ArrivalWrapper_Line.objectFrom(data, { handler(nil, $0) }) {
                        handler(wrapper.stops, nil)
                    }
                case .failure(let error):
                    handler(nil, error)
                }
        }
        
    }
    
    static func nextArrivals(at stop: OVStop, _ retryHelper: RetryHelperBlock? = nil,
                             handler: @escaping ListResponseHandler<LineSummary>) {
        
        _ = OVNetwork.olhoVivoRequest(.arrivals(of: nil, at: stop), retryHelper)
            .responseData { response in
                
                switch response.result {
                case .success(let data):
                    if let wrapper = ArrivalWrapper_Stop.objectFrom(data, { handler(nil, $0) }) {
                        handler(wrapper.lines, nil)
                    }
                case .failure(let error):
                    handler(nil, error)
                }
        }
    }
    
}
