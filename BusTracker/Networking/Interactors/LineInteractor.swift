//
//  LineInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct LineInteractor {
    
    typealias LineResponseHandler = ([BusLine]?, Error?) -> Void
    
    static func search(_ searchQuery: String, direction: BusLine.Direction? = nil,
                       handler: @escaping LineResponseHandler) {
        
        BTNetwork.olhoVivoRequest(BTRequest.searchLine(query: searchQuery, direction: direction),
                                  showRetryAlert: true)
            .responseData { (response) in
                
                switch response.result {
                case .success(let data):
                    
                    do {
                        let json = try JSONDecoder().decode([BusLine].self, from: data)
                        handler(json, nil)
                        return
                    } catch let decodingError {
                        handler(nil, decodingError)
                        return
                    }
                    
                case .failure(let error):
                    handler(nil, error)
                    return
                }
        }
    }
    
}
