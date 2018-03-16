//
//  RegisterVC.swift
//  CoursePlanner
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        guard let firstName = firstField.text, firstField.text != "" else {
            print("No first")
            return
        }
        guard let lastName = lastField.text, lastField.text != "" else {
            print("No last")
            return
        }
        guard let username = userField.text, userField.text != "" else {
            print("No user")
            return
        }
        guard let password = passField1.text, passField1.text != "", passField1.text == passField2.text else {
            print("No password")
            return
        }
        
        let email:String? = (emailField.text == "") ? nil : emailField.text
        
        self.view.isUserInteractionEnabled = false
        
        RestAPI.register(user: username, password: password, first: firstName, last: lastName, email: email) { (error) in
            DispatchQueue.main.async {
                
                self.view.isUserInteractionEnabled = true
                //self.activityIndicator.stopAnimating()
                
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
