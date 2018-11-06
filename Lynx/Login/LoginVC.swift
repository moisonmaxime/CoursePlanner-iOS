//
//  LoginVC.swift
//  Lynx
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameInput: UIView!
    @IBOutlet weak var passwordInput: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        usernameInput.setCornerRadius(at: 5)
        passwordInput.setCornerRadius(at: 5)
        loginButton.setCornerRadius(at: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginClick(_ sender: Any) {
        navigationController?.didStartLoading()  // start loading animation

        guard let user = userField.text, let password = passwordField.text else {
            return
        }

        RestAPI.login(user: user, password: password, completionHandler: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.setAnimationType(type: FadingAnimation.self, forever: false)
            let home = strongSelf.storyboard?.instantiateViewController(withIdentifier: "Home")
            strongSelf.navigationController?.setViewControllers([home!], animated: true)
        }, errorHandler: handleError)
    }

}
