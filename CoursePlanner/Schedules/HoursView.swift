//
//  hoursView.swift
//  WeekCalendar
//
//  Created by Maxime Moison on 2/10/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

internal class HoursView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let p = superview! as! CalendarView
        
        p.legendColor.setFill()
        UIBezierPath(rect: rect).fill()
        
        if (p.endHour > p.startHour) {
            for i in 0...(p.endHour - p.startHour - 1) {
                let y = p.hourHeight * CGFloat(i)
                let r = CGRect(x: rect.minX, y: y, width: frame.width - frame.width/5, height: 12)
                
                let lbl = UILabel(frame: r)
                lbl.textAlignment = .right
                lbl.font = lbl.font.withSize(10)
                lbl.textColor = p.legendTextColor
                
                let hour = i + p.startHour
                if (hour < 12) {
                    lbl.text = "\(hour)am"
                } else if (hour > 12) {
                    lbl.text = "\(hour - 12)pm"
                } else {
                    lbl.text = "Noon"
                }
                addSubview(lbl)
            }
        }
    }
}
