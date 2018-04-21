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
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = (UserDefaults.standard.string(forKey: "username") ?? "USERNAME").capitalized
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "api_token") // Clear token
        /*(self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
         let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
         self.navigationController?.setViewControllers([login!], animated: true)*/
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
