//
//  EventView.swift
//  WeekCalendar
//
//  Created by Maxime Moison on 2/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

internal class EventView: UIView {

    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var timeLbl: UILabel!
    private var color:UIColor = UIColor.orange
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ dirtyRect: CGRect) {
        let rect = CGRect(x: dirtyRect.origin.x + 1, y: dirtyRect.origin.y, width: dirtyRect.width - 2, height: dirtyRect.height)
        
        titleLbl.textColor = color.darker()
        
        if (self.frame.height < (timeLbl.frame.height + titleLbl.frame.height)) {
            timeLbl.isHidden = true
        } else {
            timeLbl.isHidden = false
            timeLbl.textColor = color.darker()
        }
        
        let background = UIBezierPath(rect: rect)
        color.withAlphaComponent(0.5).setFill()
        background.fill()
        UIColor.white.withAlphaComponent(0.5).setFill()
        background.fill()
        
        let border = UIBezierPath(rect: CGRect(x: rect.origin.x, y: rect.origin.y, width: 2, height: rect.height))
        color.setFill()
        border.fill()
    }
    
    func setup(frame: CGRect, color: UIColor, start: String, name: String) {
        self.frame = frame
        self.color = color
        titleLbl.text = name
        timeLbl.text = start
    }

}


