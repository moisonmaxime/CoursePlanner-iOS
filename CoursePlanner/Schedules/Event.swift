//
//  Event.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/1/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class Event: UIView {

    @IBOutlet weak var courseID: UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let back = UIBezierPath(rect: rect)
        tintColor.withAlphaComponent(0.5).setFill()
        back.fill()
        UIColor.white.withAlphaComponent(0.3).setFill()
        back.fill()
        
        let leftLine = UIBezierPath()
        leftLine.move(to: CGPoint(x: rect.minX, y: rect.minY))
        leftLine.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        leftLine.lineWidth = 4
        tintColor.darker().setStroke()
        leftLine.stroke()
        
        courseID.textColor = tintColor.darker()
    }
    

}
