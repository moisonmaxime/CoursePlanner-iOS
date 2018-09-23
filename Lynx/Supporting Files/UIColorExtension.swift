//
//  UIColorExtension.swift
//  Lynx
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension UIColor {

    func darker() -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor.init(hue: hue, saturation: saturation, brightness: brightness * 0.75, alpha: alpha)
    }

}
