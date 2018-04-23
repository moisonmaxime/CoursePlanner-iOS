//
//  LoginVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginClick(_ sender: Any) {
        self.view.isUserInteractionEnabled = false  // disable user interaction
        (self.navigationController as! NavigationController).didStartLoading()  // start loading animation
        
        RestAPI.login(user: userField.text!, password: passwordField.text!) { error in  // Try Login API Call
            
            // Actions have to be done in the main thread
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true   // reenable user interaction
                if (error != nil) {
                    // stop loading animation, display error alert
                    (self.navigationController as! NavigationController).didFinishLoading()
                    self.handleError(error: error!)
                } else {
                    // Navigate to homepage
                    (self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
                    let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.navigationController?.setViewControllers([home!], animated: true)
                }
            }
        }
    }
    
}
