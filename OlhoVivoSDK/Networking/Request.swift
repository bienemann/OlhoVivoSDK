//
//  Request.swift
//  BusTracker
//
//  Created by Allan Martins on 06/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

internal enum OVRequest: URLRequestConvertible {
     
    static internal let base_url = "http://api.olhovivo.sptrans.com.br/"
    static internal let api_version = "v2.1"
    
    enum StopsFilters {
        case search(_: String)
        case line(_: OVLine)
        case corridor(_: OVCorridor)
    }
    
    case authenticate(token: String)
    case searchLine(query: String, direction: OVLine.Direction?)
    case stops(by: StopsFilters)
    case positions(OVLine)
    case arrivals(of: OVLine?, at: OVStop?)
    
    private var forcedQuery: Bool {
        switch self {
        case .authenticate,
             .searchLine,
             .stops,
             .positions,
             .arrivals:
            return true
        }
    }
    
    private var endpoint: String? {
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
                return "/Parada/BuscarParadasPorLinha"
            case .corridor:
                return "/Parada/BuscarParadasPorCorredor"
            }
        case .positions:
            return "/Posicao/Linha"
        case .arrivals(let line, let stop):
            if let _ = line, let _ = stop { // search both line and stop
                return "/Previsao"
            } else if let _ = line { // all arrivals for line
                return "/Previsao/Linha"
            } else if let _ = stop { // all arrivals for this stop
                return "/Previsao/Parada"
            } else {
                return nil
            }
        }
        
    }
    
    private var method: HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        case .searchLine, .stops, .positions, .arrivals:
            return .get
        }
    }
    
    private var params: Parameters? {
        switch self {
        case .authenticate(let token):
            return ["token": token]
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
            case .line(let line):
                return ["codigoLinha": line.lineID]
            case .corridor(let corridor):
                return ["codigoCorredor": corridor.corridorID]
            }
        case .positions(let line):
            return ["codigoLinha": line.lineID]
        case .arrivals(let line, let stop):
            if let line = line, let stop = stop {
                
                return ["codigoParada": stop.stopID,
                        "codigoLinha": line.lineID]
                
            } else if let line = line {
                
                return ["codigoLinha": line.lineID]
                
            } else if let stop = stop {
                
                return ["codigoParada": stop.stopID]
                
            } else {
                return nil
            }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        guard let endpoint = endpoint else {
            throw NSError(domain: URLError.errorDomain, code: URLError.badURL.rawValue, userInfo: nil)
        }
        
        let url = try (OVRequest.base_url + OVRequest.api_version).asURL()
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
