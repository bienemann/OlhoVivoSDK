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
        BTNetwork.retriableRequest(BTRequest.searchLine(query: "dom pedro")).responseData { response in
            print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

