//
//  ProfileVC.swift
//  Lynx
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
    @IBOutlet var inputs: [UIView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for input in inputs {
            input.layer.borderWidth = 0.75
            input.layer.borderColor = UIColor(named: "ButtonColor")?.cgColor
            input.setCornerRadius(at: 5)
        }
        
        hideKeyboardWhenTappedAround()
        fullNameLabel.text = ""
        if let userInfo = UserSettings.userInformation {
            updateUI(with: userInfo)
        }
    }
    
    private func updateUI(with userInfo: UserInformation) {
        self.usernameLabel.text = userInfo.username.capitalized
        self.fullNameLabel.text = userInfo.name.capitalized
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
                if pass1.text == pass2.text {
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

        UserSettings.accessKey = nil

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
