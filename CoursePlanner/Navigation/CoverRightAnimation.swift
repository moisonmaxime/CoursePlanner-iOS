//
//  CoverRightAnimation.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/17/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

import UIKit

class CoverRightAnimation: NSObject, Animation {
    var isPresenting: Bool
    var duration : TimeInterval
    
    required init(duration: TimeInterval, isPresenting: Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let detailView = isPresenting ? toView : fromView
        let rootView = !isPresenting ? toView : fromView
        
        if (!isPresenting) {
            rootView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            rootView.alpha = 0.3
            container.insertSubview(toView, belowSubview: fromView)
        } else {
            detailView.transform = CGAffineTransform(translationX: container.frame.width, y: 0)
            container.insertSubview(toView, aboveSubview: fromView)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in // Animate the transition
            rootView.alpha = self.isPresenting ? 0.3 : 1
            rootView.transform = self.isPresenting ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform(scaleX: 1, y: 1)
            detailView.frame = self.isPresenting ? container.frame : detailView.frame.offsetBy(dx: container.frame.width, dy: 0)
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
