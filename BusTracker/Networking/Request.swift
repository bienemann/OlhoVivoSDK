//
//  Request.swift
//  BusTracker
//
//  Created by Allan Martins on 06/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

enum BTRequest: URLRequestConvertible {
    
    static private let base_url = "http://api.olhovivo.sptrans.com.br/"
    static private let api_version = "v2.1"
    
    case authenticate
    
    private var forcedQuery: Bool {
        switch self {
        case .authenticate:
            return true
        }
    }
    
    private var endpoint: String {
        switch self {
        case .authenticate:
            return "/Login/Autenticar"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        }
    }
    
    private var params: Parameters {
        switch self {
        case .authenticate:
            return ["token": "e86972bad776dfaaba882db93230bf1b4745a4c9d21ddfcd15c71106d2fa6f79"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try (BTRequest.base_url + BTRequest.api_version).asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint))
        urlRequest.httpMethod = method.rawValue
        if forcedQuery {
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: params)
        } else {
            urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
    
    
}
