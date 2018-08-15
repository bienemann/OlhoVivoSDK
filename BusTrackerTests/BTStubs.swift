//
//  BTStubs.swift
//  BusTrackerTests
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import XCTest
import Foundation
import OHHTTPStubs

@testable import BusTracker

struct BTStubs { // Auth
    
    static func basicStub(_ request: URLRequest?, file: String, statusCode: Int32) {
        
        stub(condition: { testRequest -> Bool in
            
            guard let request = request else {
                return false
            }
            return  testRequest.url == request.url
            
        }) { _ in
            
            guard
                let testBundle = Bundle(identifier: "com.aya.BusTrackerTests"),
                let filePath = testBundle.path(forResource: file, ofType: "json")
                else {
                    let error = NSError(domain: NSURLErrorDomain,
                                        code: NSURLErrorFileDoesNotExist,
                                        userInfo: nil)
                    return OHHTTPStubsResponse(error: error)
            }
            
            return OHHTTPStubsResponse(
                fileAtPath: filePath,
                statusCode: statusCode,
                headers: nil)
        }
        
    }
}

extension BTStubs { // Auth
    
    static func stubAuthSuccess() {
        do {
            let request = try BTRequest.authenticate.asURLRequest()
            basicStub(request, file: "authenticate_success", statusCode: 200)
        } catch {
            return
        }
    }
    
    static func stubAuthFailure() {
        do {
            let request = try BTRequest.authenticate.asURLRequest()
            basicStub(request, file: "authenticate_fail", statusCode: 200)
        } catch {
            return
        }
    }
    
}

extension BTStubs { // Lines
    
    static func stubSearch(_ query: String, direction: BusLine.Direction? = nil) {
        
        var fileName = "linha_buscar_termosBusca_" + query
        if let direction = direction {
            fileName = "linha_buscarLinhaSentido_termosBusca_" + query +
            "_sentido_\(direction.rawValue)"
        }
        
        do {
            let request = try BTRequest.searchLine(query: query, direction: direction).asURLRequest()
            basicStub(request, file: fileName, statusCode: 200)
        } catch {
            return
        }
        
    }
    
    static func stubSearchUnauthorized(_ query: String) {
        
        do {
            let request = try BTRequest.searchLine(query: query, direction: nil).asURLRequest()
            basicStub(request, file: "unauthorized", statusCode: 401)
        } catch {
            return
        }
        
    }
}

extension BTStubs { // Stops
    
    static func stubStopsSearch(_ query: String) {
        
        var filename = "parada_buscar_termosBusca_"
        filename += query
        
        do {
            let request = try BTRequest.stops(by: .search(query)).asURLRequest()
            basicStub(request, file: filename, statusCode: 200)
        } catch {
            return
        }
        
    }
    
    static func stubStops(by line: BusLine) {
        var filename = "parada_buscarParadaPorLinha_codigoLinha_"
        filename += line.lineID.description
        do {
            let request = try BTRequest.stops(by: .line(line)).asURLRequest()
            basicStub(request, file: filename, statusCode: 200)
        } catch {
            return
        }
    }
    
    static func stubStops(by corridor: Corridor) {
        var filename = "parada_buscarParadasPorCorredor_codigoCorredor_"
        filename += corridor.corridorID.description
        do {
            let request = try BTRequest
                .stops(by: .corridor(corridor)).asURLRequest()
            basicStub(request, file: filename, statusCode: 200)
        } catch {
            return
        }
    }
}

extension BTStubs { // Position
    
    static func stubPosition(line: BusLine) {
        
        let filename = "posicao_linha_codigoLinha_\(line.lineID)"
        
        do {
            let request = try BTRequest.positions(line).asURLRequest()
            basicStub(request, file: filename, statusCode: 200)
        } catch {
            return
        }
        
    }
    
}

extension BTStubs { // Arrivals
    
    static func stubSpecificArrivals(line: BusLine, stop: BusStop) {
        let filename = "previsao_codigoParada_\(stop.stopID)_codigoLinha_\(line.lineID)"
        do {
            let request = try BTRequest.arrivals(of: line, at: stop).asURLRequest()
            basicStub(request, file: filename, statusCode: 200)
        } catch {
            return
        }
    }
    
    static func stubArrivals(of line: BusLine) {
        let filename = "previsao_linha_codigoLinha_\(line.lineID)"
        do {
            let request = try BTRequest.arrivals(of: line, at: nil).asURLRequest()
            basicStub(request, file: filename, statusCode: 200)
        } catch {
            return
        }
    }
    
}
