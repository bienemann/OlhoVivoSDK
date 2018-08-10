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
        let json = try? JSONDecoder().decode([Self].self, from: data)
        return json
    }
    
    static func listFrom(_ data: Data, _ handler: AutoDecodingErrorHandler? = nil) -> [Self]? {
        
        do {
            let json = try JSONDecoder().decode([Self].self, from: data)
            return json
        } catch let error {
            if handler != nil {
                handler!(error)
            }
        }
        
        return nil
    }
}
