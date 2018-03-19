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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboardWhenTappedAround()
        (navigationController as! NavigationController).setAnimationType(type: CoverRightAnimation.self, isRepeating: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClick(_ sender: Any) {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        RestAPI.login(user: userField.text!, password: passwordField.text!) { error in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                if (error != nil) {
                    self.handleError(error: error!)
                } else {
                    (self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
                    let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.navigationController?.setViewControllers([home!], animated: true)
                }
            }
        }
    }
    
}
