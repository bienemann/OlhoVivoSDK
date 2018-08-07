//
//  ViewController.swift
//  BusTracker
//
//  Created by Allan Martins on 06/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(BTRequest.authenticate).responseData { response in
            print(response.result)
            
            switch response.result {
            case .success:
                guard
                    let data = response.result.value,
                    let responseString = String(data: data, encoding: .utf8), responseString == "true"
                else {
                    print("response false or invalid")
                    return
                }
                print("authenticated")
                return
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

