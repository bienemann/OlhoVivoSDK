//
//  DecodableExtension.swift
//  BusTracker
//
//  Created by Allan Martins on 10/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

extension Decodable {
    
    typealias AutoDecodingErrorHandler = (Error) -> Void
    
    static func listFrom(_ data: Data) -> [Self]? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let json = try? decoder.decode([Self].self, from: data)
        return json
    }
    
    static func objectFrom(_ data: Data, _ handler: AutoDecodingErrorHandler? = nil) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let json = try decoder.decode(Self.self, from: data)
            return json
        } catch let error {
            if handler != nil {
                handler!(error)
            }
        }
        
        return nil
    }
    
    static func listFrom(_ data: Data, _ handler: AutoDecodingErrorHandler? = nil) -> [Self]? {
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let json = try decoder.decode([Self].self, from: data)
            return json
        } catch let error {
            if handler != nil {
                handler!(error)
            }
        }
        
        return nil
    }
}
