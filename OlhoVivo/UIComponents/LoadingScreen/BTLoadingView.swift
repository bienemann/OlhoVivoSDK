//
//  MDLoadingView.swift
//  McEntrega
//
//  Created by Allan Martins on 28/10/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import UIKit

public final class BTLoadingView: NSObject {
    
    public static let shared = BTLoadingView()
    
    private let defaultAnimationTime: TimeInterval = 0.5
    public var customAnimationDuration: TimeInterval?
    public var isLoading: Bool = false
    
    private var didDismissHandler: DidFinishDismissingHandler?
    private var animationView: UIView!
    
    @IBOutlet var view: UIView!
    @IBOutlet private var smallView: UIView!
    
    // MARK: - LifeCycle
    
    public override init() {
        super.init()
        Bundle.main.loadNibNamed("BTLoadingView", owner: self, options: nil)
        initAnimationView()
    }
    
    // MARK: - Public
    
    public func show(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground),
                                               name: .UIApplicationWillEnterForeground, object: nil)
        
        if self.isLoading { return }
        self.prepareToShow()
        self.animateIntoScreen(duration: animated ? self.animationDuration(): 0)
        
    }
    
    public func dismiss(_ animated: Bool, handler: DidFinishDismissingHandler? = nil) {
        
        NotificationCenter.default.removeObserver(self)
        self.didDismissHandler = handler
        self.animateOutOfScreen(duration: animated ? self.animationDuration(): 0)
    }
    
    // private
    
    @objc private func didEnterForeground() {
        if isLoading {
            // play animation
        }
    }
    
    private func initAnimationView() {
        
        // Instantiate animation view
//        self.animationView = LOTAnimationView(name: "loading", bundle: Bundle.projectBundle())
        
        self.animationView.frame = CGRect(x: 0, y: 0,
                                          width: self.smallView.frame.size.width,
                                          height: self.smallView.frame.size.height)
        self.animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.animationView.contentMode = .scaleAspectFill
        self.animationView.clipsToBounds = false
        
        self.smallView.addSubview(animationView)
        self.view.layoutIfNeeded()
        
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
        
//        self.animationView.play()
        
        self.smallView.alpha = 0.0
        self.view.frame = window!.frame
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.view.layoutIfNeeded()
        
        window?.addSubview(self.view)
        
    }
    
    private func animateIntoScreen(duration: TimeInterval) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(
            withDuration: duration,
            animations: {
                self.smallView.alpha = 1.0
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                self.view.layoutIfNeeded()
        },
            completion: { _ in
                self.didFinishShowing()
        })
    }
    
    private func didFinishShowing() {
        isLoading = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func animateOutOfScreen(duration: TimeInterval) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(
            withDuration: duration,
            animations: {
                self.smallView.alpha = 0.0
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.view.layoutIfNeeded()
        },
            completion: { _ in
//                self.animationView.stop()
                self.didFinishHiding()
        })
    }
    
    private func didFinishHiding() {
        UIApplication.shared.endIgnoringInteractionEvents()
        guard let handler = self.didDismissHandler else {
            self.view.removeFromSuperview()
            isLoading = false
            return
        }
        handler()
        self.view.removeFromSuperview()
        isLoading = false
    }
}
