//
//  PositionInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 14/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

internal struct PositionInteractor {
    
    static func list(for line: OVLine, _ retryHelper: RetryHelperBlock? = nil,
                     handler: @escaping ListResponseHandler<OVPosition>) {
        _ = OVNetwork.olhoVivoRequest(.positions(line), retryHelper)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let wrapper = PositionWrapper.objectFrom(data, { handler(nil, $0) }) {
                        handler(wrapper.positions, nil)
                    }
                case .failure(let error):
                    handler(nil, error)
                }
        }
    }
    
}
