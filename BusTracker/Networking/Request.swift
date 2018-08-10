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
    
    enum StopsFilters {
        case search(_: String)
        case line(_: BusLine)
        case corridor(_: AnyObject)
    }
    
    case authenticate
    case searchLine(query: String, direction: BusLine.Direction?)
    case stops(by: StopsFilters)
    
    private var forcedQuery: Bool {
        switch self {
        case .authenticate,
             .searchLine,
             .stops:
            return true
        }
    }
    
    private var endpoint: String {
        switch self {
        case .authenticate:
            return "/Login/Autenticar"
        case .searchLine(_, let direction):
            guard let _ = direction else {
                return "/Linha/Buscar"
            }
            return "/Linha/BuscarLinhaSentido"
        case .stops(let filter):
            switch filter {
            case .search:
                return "/Parada/Buscar"
            case .line:
                return ""
            case .corridor:
                return ""
            }
        }
        
    }
    
    private var method: HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        case .searchLine, .stops:
            return .get
        }
    }
    
    private var params: Parameters {
        switch self {
        case .authenticate:
            return ["token": "e86972bad776dfaaba882db93230bf1b4745a4c9d21ddfcd15c71106d2fa6f79"]
        case .searchLine(let searchQuery, let direction):
            guard let direction = direction else {
                return ["termosBusca": searchQuery]
            }
            return  ["termosBusca": searchQuery,
                    "sentido": direction.rawValue]
        case .stops(let filter):
            switch filter {
            case .search(let searchQuery):
                return ["termosBusca": searchQuery]
            default:
                return [:]
            }
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
