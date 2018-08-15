//
//  ArrivalInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

struct ArrivalInteractor {
    
    static func nextArrivals(of line: BusLine?,
                             at stop: BusStop,
                             handler: @escaping ListResponseHandler<BusPosition>) {
        
        _ = BTNetwork.olhoVivoRequest(.arrivals(of: line, at: stop))
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
    
    static func nextArrivals(of line: BusLine, handler: @escaping ListResponseHandler<BusStop>) {
        
        _ = BTNetwork.olhoVivoRequest(.arrivals(of: line, at: nil))
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
    
    static func nextArrivals(at stop: BusStop, handler: @escaping ListResponseHandler<LineSummary>) {
        
        _ = BTNetwork.olhoVivoRequest(.arrivals(of: nil, at: stop))
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
