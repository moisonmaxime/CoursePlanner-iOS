//
//  ProfileVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/19/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var pass2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        fullNameLabel.text = ""
        RestAPI.getUserInfo { (info, error) in
            DispatchQueue.main.async {
                if (error != nil) {
                    self.handleError(error: error!)
                } else {
                    self.usernameLabel.text = info?["username"]?.capitalized
                    self.fullNameLabel.text = info?["name"]?.capitalized
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordDone(_ sender: Any) {
        pass2.endEditing(true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let password = pass1.text, pass1.text != "", pass1.text == pass2.text else {
            if (pass1.text == pass2.text) {
                displayAlert(message: "Password required")
            } else {
                displayAlert(message: "Passwords are not matching")
            }
            return
        }
        
        RestAPI.changePassword(oldPass: oldPass.text!, newPass: password) { (error) in
            DispatchQueue.main.async {
                if (error != nil) {
                    self.handleError(error: error!)
                } else {
                    self.displayAlert(title: "Success", message: "Your Password was changed")
                }
            }
        }
    }
    
    @IBAction func logout() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: {
            let nav = UIApplication.shared.delegate?.window??.rootViewController as! NavigationController
            nav.setAnimationType(type: FadingAnimation.self, isRepeating: false)
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            nav.setViewControllers([home!], animated: true)
        })
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
