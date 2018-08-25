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
    
    
    // Display PopUp Alert
    func displayAlert(title: String="Error", message: String, handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // ### - Handle API errors
    func handleError(error: APIError) {
        let message:String = error.message
        if error == .invalidAPIKey {
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
            displayAlert(message: message, handler: { (action) in
                (self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
                let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.setViewControllers([login!], animated: true)
            })
            return
        }
        
        // print("Error: \(message)")
        
        self.displayAlert(message: message, handler: nil)
    }
    
    
    // ### - Go Back button
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func selectTerm(completion: @escaping (String)->()) {
        let terms = UserDefaults.standard.object(forKey: "terms") as! [String]
        
        let termSelector = UIAlertController(title: "Choose a term", message: nil, preferredStyle: .actionSheet)
        for term in terms {
            termSelector.addAction(.init(title: term.readableTerm(), style: .default, handler: { (action) in
                completion(action.title!.termID())
            }))
        }
        
        termSelector.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(termSelector, animated: true, completion: nil)
    }
    
    
    // ### - Tap to dismiss keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissField() {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // ###
    
}
