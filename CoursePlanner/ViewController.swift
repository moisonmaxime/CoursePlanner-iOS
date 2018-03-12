//
//  ViewController.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClick(_ sender: Any) {
        activityIndicator.startAnimating()
        RestAPI.login(user: userField.text!, password: passwordField.text!) { (isSuccess, error) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            if error != nil {
                var msg:String
                
                switch (error!) {
                case APIError.Unauthorized:
                    msg = "Wrong Credentials"
                    break
                default:
                    msg = "Unknown Error"
                    break
                }
                print("Error: \(msg)")
                return
            }
            
            print(isSuccess ? "Successful" : "Failed")
        }
    }
    
}
