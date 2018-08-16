//
//  ViewController.swift
//  BusTracker
//
//  Created by Allan Martins on 06/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import UIKit
import OlhoVivoSDK

class ViewController: UIViewController {

    let api = OlhoVivo(token: "e86972bad776dfaaba882db93230bf1b4745a4c9d21ddfcd15c71106d2fa6f79")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchExample(_ sender: UIButton) {
        
        api.lines("campo limpo") { (lines, error) in
            _ = lines?.compactMap{ print($0.outboundName) }
        }
        
    }


}

