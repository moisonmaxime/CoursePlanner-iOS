//
//  NavigationController.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var animationType:Animation.Type?
    var defaultAnimationType:Animation.Type?
    var willRevert:Bool = false
    
    var interactor:InteractiveTransition!
    
    var loadingViews:[UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = .clear
        interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == interactivePopGestureRecognizer) {
            if (viewControllers.count <= 1) {
                return false
            }
        }
        return true
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let currentAnimationType:Animation.Type = animationType, animationType != nil  else {
            return nil
        }
        
        if (willRevert) {
            animationType = defaultAnimationType
            willRevert = false
        }
        
        let duration = self.isNavigationBarHidden ? 0.4 : TimeInterval(UINavigationControllerHideShowBarDuration)
        
        switch operation {
        case .push:
            self.interactor = InteractiveTransition(attachTo: toVC)
            return currentAnimationType.init(duration: duration, isPresenting: true)
        default:
            return currentAnimationType.init(duration: duration, isPresenting: false)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transitioner = interactor else { return nil }
        return transitioner.transitionInProgress ? interactor : nil
    }
    
    func setAnimationType(type: Animation.Type, isRepeating: Bool) {
        if (isRepeating) {
            defaultAnimationType = type
        }
        animationType = type
        willRevert = !isRepeating
    }
    
    func didStartLoading(immediately: Bool=false) {
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
        loadingViews.append(loadingView)
        
        if (!immediately) {
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                loadingView.alpha = 1
            }
        }
    }
    
    func didFinishLoading() {
        for v in loadingViews {
            UIView.animate(withDuration: 0.5, animations: {
                v.alpha = 0
            }, completion: { _ in
                v.removeFromSuperview()
            })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
