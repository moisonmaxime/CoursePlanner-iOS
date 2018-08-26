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
        navigationController?.didStartLoading()  // start loading animation
        
        guard let user = userField.text, let password = passwordField.text else {
            return
        }
        
        RestAPI.login(user: user, password: password, completionHandler: {
            self.navigationController?.setAnimationType(type: FadingAnimation.self, forever: false)
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.navigationController?.setViewControllers([home!], animated: true)
        }, errorHandler: handleError)
    }
    
}
