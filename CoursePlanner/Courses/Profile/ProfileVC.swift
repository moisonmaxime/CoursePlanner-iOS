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
        RestAPI.getUserInfo(completionHandler: { info in
            self.usernameLabel.text = info["username"]?.capitalized
            self.fullNameLabel.text = info["name"]?.capitalized
            self.usernameLabel.alpha = 0
            self.fullNameLabel.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.usernameLabel.alpha = 1
                self.fullNameLabel.alpha = 1
            })
        }, errorHandler: handleError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordDone(_ sender: Any) {
        pass2.endEditing(true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let oldPass = oldPass.text,
            let password = pass1.text,
            pass1.text != "",
            pass1.text == pass2.text else {
                if (pass1.text == pass2.text) {
                    displayAlert(message: "Password required")
                } else {
                    displayAlert(message: "Passwords are not matching")
                }
                return
        }
        
        RestAPI.changePassword(oldPass: oldPass, newPass: password, completionHandler: {
            self.displayAlert(title: "Success", message: "Your Password was changed")
        }, errorHandler: handleError)
    }
    
    @IBAction func logout() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: {
            let nav = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
            nav?.setAnimationType(type: FadingAnimation.self, forever: false)
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            nav?.setViewControllers([home!], animated: true)
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
