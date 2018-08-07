//
//  ErrorAlert.swift
//  McEntrega
//
//  Created by Allan Martins on 25/11/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import UIKit

final class RetryAlert: NSObject, BTAlertViewProtocol {
    
    public var controller: BTAlertController?
    
    var dismissOnTouchOutside: Bool = false
    var retryHandler: (() -> Void)?
    var closeAlertHandler: (() -> Void)?
    var message: String?
    
    @IBOutlet weak internal var view: UIView!
    @IBOutlet private weak var btnTryAgain: UIButton!
    @IBOutlet private weak var btnClose: UIButton!
    @IBOutlet private weak var lblWarningText: UILabel!
    
    @IBAction private func retry(sender: UIButton) {
        guard let callback = self.retryHandler else {
            return
        }
        callback()
    }
    
    func dismiss(animated: Bool, _ handler: DidFinishDismissingHandler?) {

    }
    @IBAction private func close(sender: UIButton) {
        guard let callback = self.closeAlertHandler else {
            return
        }
        callback()
        self.dismiss(animated: true)
    }
    
    func localize() {
        self.lblWarningText.text = message
        return
    }
    
}
