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
    func handleError(error: APIError) {
        DispatchQueue.main.async {
            debugPrint("Error")
            switch (error) {
            case .InternalError:
                debugPrint("Internal Error")
                break
            case .InvalidAPIKey:
                debugPrint("Invalid API Key")
                break
            case .ServerError:
                debugPrint("Server Error")
                break
            case .NetworkError:
                debugPrint("Network Error")
                break
            }
        }
    }
}
