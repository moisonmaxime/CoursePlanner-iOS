//
//  CustomAnimator.swift
//  Lynx
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class FadingAnimation: NSObject, Animation {
    var isPresenting: Bool
    var duration: TimeInterval

    required init(duration: TimeInterval, isPresenting: Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        container.addSubview(toView)

        let detailView = toView
        detailView.alpha = 0

        UIView.animate(withDuration: duration, animations: {
            detailView.alpha = 1
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
