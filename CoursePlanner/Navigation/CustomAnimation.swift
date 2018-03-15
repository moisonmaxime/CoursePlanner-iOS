//
//  CustomAnimation.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol CustomAnimation: UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval {get set}
    var isPresenting : Bool {get set}
    init(duration : TimeInterval, isPresenting: Bool)
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
}
