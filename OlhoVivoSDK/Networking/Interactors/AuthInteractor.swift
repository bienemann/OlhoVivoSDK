//
//  AuthInteractor.swift
//  BusTracker
//
//  Created by Allan Martins on 07/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import Alamofire

internal typealias AuthenticationHandler = (Bool) -> Void
internal class AuthInteractor {
    
    static let shared = AuthInteractor()
    internal var token: String?
    
    func authenticate(_ completionHandler: @escaping AuthenticationHandler) {
        
        guard let token = token else { return }
        
        OVNetwork.olhoVivoRequest(OVRequest.authenticate(token: token))
            .validate({ (request, response, data) -> Request.ValidationResult in
                if  request?.url?.absoluteString.range(of: "token") != nil, response.statusCode == 200,
                    let data = data, let responseValue = String(data: data, encoding: .utf8),
                    responseValue == "true" {
                    return Request.ValidationResult.success
                } else {
                    return Request.ValidationResult.failure(NSError(domain: NSURLErrorDomain, code: URLError.userAuthenticationRequired.rawValue, userInfo: nil))
                }
        }).responseData { response in
            
            switch response.result {
            case .success:
                guard
                    let data = response.result.value,
                    let responseString = String(data: data, encoding: .utf8), responseString == "true"
                    else {
                        completionHandler(false)
                        return
                }
                completionHandler(true)
                return
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        }
    }
    
}
