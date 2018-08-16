//
//  OlhoVivo.swift
//  OlhoVivoSDK
//
//  Created by Allan Martins on 15/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

open class OlhoVivo {
    
    required public init(token: String) {
        AuthInteractor.shared.token = token
    }
    
    public func lines(_ query: String, _ direction: OVLine.Direction? = nil,
               _ retryHandler: RetryHelperBlock? = nil,
               _ responseHandler: @escaping ListResponseHandler<OVLine>) {
        LineInteractor.search(query, direction: direction, retryHandler, handler: responseHandler)
    }
    
    public func stops(search: String, _ retryHandler: RetryHelperBlock? = nil,
                      _ responseHandler: @escaping ListResponseHandler<OVStop>) {
        BusStopInteractor.search(search, retryHandler, handler: responseHandler)
    }
    
    public func nextArrivals(of line: OVLine, at stop: OVStop, _ retryHandler: RetryHelperBlock? = nil,
                             _ responseHandler: @escaping ListResponseHandler<OVPosition>) {
        ArrivalInteractor.nextArrivals(of: line, at: stop, retryHandler, handler: responseHandler)
    }
}

extension OVStop {
    
    public func getNextArrivals(_ retryHandler: RetryHelperBlock? = nil,
                                _ responseHandler: @escaping ListResponseHandler<LineSummary>) {
        ArrivalInteractor.nextArrivals(at: self, retryHandler, handler: responseHandler)
    }
    
}

extension OVLine {
    
    public func getNextArrivals(_ retryHandler: RetryHelperBlock? = nil,
                                _ responseHandler: @escaping ListResponseHandler<OVStop>) {
        ArrivalInteractor.nextArrivals(of: self, retryHandler, handler: responseHandler)
    }
    
    public func getPositions(_ retryHandler: RetryHelperBlock? = nil,
                             _ responseHandler: @escaping ListResponseHandler<OVPosition>) {
        PositionInteractor.list(for: self, retryHandler, handler: responseHandler)
    }
    
    public func getStops(_ retryHandler: RetryHelperBlock? = nil,
                         _ responseHandler: @escaping ListResponseHandler<OVStop>) {
        BusStopInteractor.stops(for: self, retryHandler, handler: responseHandler)
    }
    
}

extension OVCorridor {
    public func getStops(_ retryHandler: RetryHelperBlock? = nil,
                         _ responseHandler: @escaping ListResponseHandler<OVStop>) {
        BusStopInteractor.stops(for: self, retryHandler, handler: responseHandler)
    }
}
