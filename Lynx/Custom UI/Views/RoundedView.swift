//
//  RoundedView.swift
//  Lynx
//
//  Created by Maxime Moison on 4/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(roundedRect: CGRect(x: rect.minX+0.2, y: rect.minY+0.2, width: rect.width-0.4, height: rect.height-0.4), cornerRadius: 5)
        #colorLiteral(red: 0.3490196078, green: 0.6470588235, blue: 0.8470588235, alpha: 1).setStroke()
        path.lineWidth = 0.5
        path.stroke()
    }

}
