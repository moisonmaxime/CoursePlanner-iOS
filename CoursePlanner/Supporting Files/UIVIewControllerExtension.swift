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
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleError(error: APIError) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            
            let message:String
            switch (error) {
            case .InternalError:
                message = "Internal Error"
                break
            case .InvalidAPIKey:
                message = "Invalid API Key"
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
            
            displayAlert(message: message)
        }
    }
}
