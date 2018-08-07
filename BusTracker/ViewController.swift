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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchExample(_ sender: UIButton) {
        BTNetwork.olhoVivoRequest(BTRequest.searchLine(query: "dom pedro"), showRetryAlert: true)
            .responseData { response in
                print(response)
        }
    }


}

