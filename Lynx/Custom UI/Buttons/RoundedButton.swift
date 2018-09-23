//
//  RoundedButton.swift
//  Lynx
//
//  Created by Maxime Moison on 4/5/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
    }
}
