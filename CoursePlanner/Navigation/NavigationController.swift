//
//  NavigationController.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var animationType:Animation.Type?
    var previousAnimationType:Animation.Type?
    var willRevert:Bool = false
    
    var interactor:InteractiveTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let currentAnimationType:Animation.Type = animationType, animationType != nil  else {
            return nil
        }
        
        if (willRevert) {
            animationType = previousAnimationType
            previousAnimationType = nil
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
        previousAnimationType = isRepeating ? animationType : nil
        animationType = type
        willRevert = !isRepeating
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
