//
//  NavigationController.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var isFading = false
    
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
        
        let duration = TimeInterval(UINavigationControllerHideShowBarDuration) > 0.4 ? TimeInterval(UINavigationControllerHideShowBarDuration) : 0.4
        
        if (isFading) {
            return FadingAnimator(duration: duration)
        }
        return nil
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        isFading = true
        super.setViewControllers(viewControllers, animated: animated)
        isFading = false
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
