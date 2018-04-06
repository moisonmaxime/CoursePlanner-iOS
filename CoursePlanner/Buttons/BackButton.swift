//
//  BackButton.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/5/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

@IBDesignable class BackButton: UIButton {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX, y: frame.midY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.minX, y: frame.midY))
        tintColor.setFill()
        path.fill()
    }
}
