//
//  NavigationController.swift
//  Lynx
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol NavigationAnimationController {
    func setAnimationType(type: Animation.Type, forever isRepeating: Bool)
    func resetAnimationType()
}

extension UINavigationController: NavigationAnimationController {
    struct AnimationSettings {
        static var animationType: Animation.Type?
        static var defaultAnimationType: Animation.Type?
        static var interactiveTransition: InteractiveTransition?
    }

    func setAnimationType(type: Animation.Type, forever isRepeating: Bool) {
        if isRepeating {
            AnimationSettings.defaultAnimationType = type
        }
        AnimationSettings.animationType = type
    }

    func resetAnimationType() {
        AnimationSettings.defaultAnimationType = nil
        AnimationSettings.animationType = nil
    }
}

protocol NavigationLoadingScreen {
    func didStartLoading(immediately: Bool)
    func didFinishLoading()
}

extension UINavigationController: NavigationLoadingScreen {
    struct DisplayedElements {
        static var loadingViews: [UIView] = []
    }

    func didStartLoading(immediately: Bool=false) {
        topViewController?.view.isUserInteractionEnabled = false
        let loadingView = UIView(frame: self.view.frame)

        let screen = UIApplication.shared.keyWindow!.frame

        let loadingLabel = UILabel(frame: CGRect(x: 32, y: screen.height/2-50, width: screen.width-64, height: 100))
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = #colorLiteral(red: 0.2156862745, green: 0.4352941176, blue: 0.6470588235, alpha: 1)
        loadingLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        loadingLabel.adjustsFontSizeToFitWidth = true
        loadingLabel.textAlignment = .center

        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        loadingView.addSubview(blurEffectView)
        loadingView.addSubview(loadingLabel)

        topViewController?.view.addSubview(loadingView)
        DisplayedElements.loadingViews.append(loadingView)

        if !immediately {
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                loadingView.alpha = 1
            }
        }
    }

    func didFinishLoading() {
        topViewController?.view.isUserInteractionEnabled = true
        for loadingView in DisplayedElements.loadingViews {
            UIView.animate(withDuration: 0.5, animations: {
                loadingView.alpha = 0
            }, completion: { _ in
                loadingView.removeFromSuperview()
                if let index = DisplayedElements.loadingViews.index(of: loadingView) {
                    DisplayedElements.loadingViews.remove(at: index)
                }
            })
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count <= 1 {
                return false
            }
        }
        return true
    }
}

extension UINavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationControllerOperation,
                                     from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let currentAnimationType: Animation.Type = AnimationSettings.animationType, AnimationSettings.animationType != nil  else {
            return nil
        }

        if AnimationSettings.animationType != AnimationSettings.defaultAnimationType {
            AnimationSettings.animationType = AnimationSettings.defaultAnimationType
        }

        let duration = self.isNavigationBarHidden ? 0.4 : TimeInterval(UINavigationControllerHideShowBarDuration)

        switch operation {
        case .push:
            AnimationSettings.interactiveTransition = InteractiveTransition(attachTo: toVC)
            return currentAnimationType.init(duration: duration, isPresenting: true)
        default:
            return currentAnimationType.init(duration: duration, isPresenting: false)
        }
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transitioner = AnimationSettings.interactiveTransition else { return nil }
        return transitioner.transitionInProgress ? AnimationSettings.interactiveTransition : nil
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = .clear
        interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
}
