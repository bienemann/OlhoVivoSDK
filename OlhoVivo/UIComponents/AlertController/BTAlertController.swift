//
//  MDAlertController.swift
//  McEntrega
//
//  Created by Allan Martins on 25/10/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import UIKit

public typealias DidFinishDismissingHandler = () -> Void

public class BTAlertController: NSObject, UIGestureRecognizerDelegate {
    
    weak var alert: BTAlertViewProtocol?
    
    private let defaultTopSpace: CGFloat = 162
    private let defaultAnimationTime: TimeInterval = 0.35
    private var isAnimating = false
    var customTopSpace: CGFloat?
    var customAnimationDuration: TimeInterval?
    private var didDismissHandler: DidFinishDismissingHandler?
    
    @IBOutlet var view: AlertControllerView!
    @IBOutlet weak private var alertTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertWidthConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    required convenience public init(_ alert: BTAlertViewProtocol) {
        
        self.init()
        self.alert = alert
        let nib = UINib(nibName: "BTAlertController", bundle: Bundle.main)
        nib.instantiate(withOwner: self, options: nil)
        
    }
    
    convenience init(_ alert: BTAlertViewProtocol, customTopSpace: CGFloat) {
        self.init(alert)
        self.customTopSpace = customTopSpace
        self.alertTopConstraint.constant = customTopSpace
    }
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.view.alert = self.alert
    }
    
    // MARK: - Public
    
    public func show(_ animated: Bool) {
        isAnimating = true
        self.prepareToShow()
        self.animateIntoScreen(duration: animated ? self.animationDuration(): 0)
    }
    
    public func dismiss(_ animated: Bool, handler: DidFinishDismissingHandler? = nil) {
		if let handler = handler {
			didDismissHandler = handler
		}
        animateOutOfScreen(duration: animated ? self.animationDuration(): 0)
    }
    
    // private
    
    @IBAction private func didTouchBackground(sender: UITapGestureRecognizer) {
        if self.alert!.dismissOnTouchOutside && !isAnimating {
            self.dismiss(true)
        }
    }
    
    private func animationDuration() -> TimeInterval {
        guard let customTime = self.customAnimationDuration else {
            return self.defaultAnimationTime
        }
        return customTime
    }
    
    private func prepareToShow() {
        
        guard let window = UIApplication.shared.delegate?.window
        else {
                return
        }
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.view.frame = window!.frame
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.alertTopConstraint.constant = self.view.bounds.height
        self.view.layoutIfNeeded()
        
        window?.addSubview(self.view)
        
    }
    
    private func animateIntoScreen(duration: TimeInterval) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.alertTopConstraint.constant = self.customTopSpace ?? self.defaultTopSpace
        UIView.animate(withDuration: duration, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            self.view.layoutIfNeeded()
        }) { finished in
            self.didFinishShowing()
			self.isAnimating = false
        }
    }
    
    private func didFinishShowing() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func animateOutOfScreen(duration: TimeInterval) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.alertTopConstraint.constant = 0 - self.view.bounds.height
        UIView.animate(withDuration: duration, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        }) { finished in
            self.didFinishHiding()
        }
        
    }
    
    private func didFinishHiding() {
        UIApplication.shared.endIgnoringInteractionEvents()
        guard let handler = self.didDismissHandler else {
            self.view.willMove(toWindow: nil)
            self.view.removeFromSuperview()
            return
        }
        self.view.willMove(toWindow: nil)
        self.view.removeFromSuperview()
        handler()
    }
    
    // MARK: - UIGestureRecognizer Delegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
}

class AlertControllerView: UIView {
    
    
    var alert: BTAlertViewProtocol?
    @IBOutlet weak var controller: BTAlertController?
    @IBOutlet weak private var alertView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.alert = self.controller?.alert
        self.alertView.addSubview(self.alert!.view)
        self.setNeedsLayout()
    }
    
}
