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
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClick(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        (self.navigationController as! NavigationController).didStartLoading()
        RestAPI.login(user: userField.text!, password: passwordField.text!) { error in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                if (error != nil) {
                    (self.navigationController as! NavigationController).didFinishLoading()
                    self.handleError(error: error!)
                } else {
                    RestAPI.getUniqueID { _ in }
                    (self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
                    let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.navigationController?.setViewControllers([home!], animated: true)
                }
            }
        }
    }
    
}
