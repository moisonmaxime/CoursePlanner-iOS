//
//  UIVIewControllerExtension.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/16/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(message: String, handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: handler))
        print(message)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleError(error: APIError) {
        let message:String
        switch (error) {
        case .InternalError:
            message = "Internal Error"
            break
        case .InvalidAPIKey:
            message = "Invalid API Key"
            UserDefaults.standard.removeObject(forKey: "api_token") // Clear token
            displayAlert(message: message, handler: { (action) in
                (self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
                let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.setViewControllers([login!], animated: true)
            })
            return
        case .InvalidCredentials:
            message = "Invalid Credentials"
            break
        case .ServerError:
            message = "Server Error"
            break
        case .NetworkError:
            message = "Network Error"
            break
        }
        
        debugPrint("Error")
        debugPrint(message)
        
        self.displayAlert(message: message, handler: nil)
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextTextField(sender: UITextField) {
        let fields = view.subviews.filter { (field) -> Bool in
            return type(of: field) == UITextField.self
        }
        if let index = fields.index(of: sender) {
            if (index+1 < fields.count) {
                fields[index+1].becomeFirstResponder()
            }
        }
    }
}
