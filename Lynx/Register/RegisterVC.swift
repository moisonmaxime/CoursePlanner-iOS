//
//  RegisterVC.swift
//  Lynx
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var lastField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField1: UITextField!
    @IBOutlet weak var passField2: UITextField!
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerPressed(_ sender: Any) {

        // Make sure all fields are filled and valid
        guard let firstName = firstField.text, firstField.text != "" else {
            displayAlert(message: "First name required")
            return
        }
        guard let lastName = lastField.text, lastField.text != "" else {
            displayAlert(message: "Last name required")
            return
        }
        guard let username = userField.text, userField.text != "" else {
            displayAlert(message: "Username required")
            return
        }
        guard let password = passField1.text, passField1.text != "", passField1.text == passField2.text else {
            if passField1.text == passField2.text {
                displayAlert(message: "Password required")
            } else {
                displayAlert(message: "Passwords are not matching")
            }
            return
        }

        // If there is an email, use it
        let email: String? = (emailField.text == "") ? nil : emailField.text

        // API Call to register (transition to Homepage if successful)
        self.navigationController?.didStartLoading()
        RestAPI.signup(user: username, password: password, first: firstName, last: lastName, email: email, completionHandler: {
            self.navigationController?.setAnimationType(type: FadingAnimation.self, forever: false)
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.navigationController?.setViewControllers([home!], animated: true)
        }, errorHandler: handleError)
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
