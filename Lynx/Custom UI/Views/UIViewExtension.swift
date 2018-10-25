//
//  UIViewExtension.swift
//  Lynx
//
//  Created by Maxime Moison on 4/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension UIView {
    func setCornerRadius(at radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
