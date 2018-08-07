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

struct BTStubs {
    
    static func stubSearch(_ query: String) {
        
        let fileName = "linha_buscar_termosBusca_" + query
        do {
            let request = try BTRequest.searchLine(query: query).asURLRequest()
            basicStub(request, file: fileName, statusCode: 200)
        } catch {
            return
        }
        
    }
    
    static func stubSearchUnauthorized(_ query: String) {
        
        do {
            let request = try BTRequest.searchLine(query: query).asURLRequest()
            basicStub(request, file: "unauthorized", statusCode: 401)
        } catch {
            return
        }
        
    }
    
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

extension BTStubs { // base constructor
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
