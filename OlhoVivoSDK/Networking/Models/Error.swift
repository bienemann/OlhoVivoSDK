//
//  Error.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct APIError: Decodable {
    
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}
