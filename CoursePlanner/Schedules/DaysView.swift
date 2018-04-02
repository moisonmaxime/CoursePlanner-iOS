//
//  daysView.swift
//  WeekCalendar
//
//  Created by Maxime Moison on 2/10/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

internal class DaysView: UIView {
    
    private let weekDays:Array<String> = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
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
        // Drawing code
        let p = superview! as! CalendarView
        
        p.legendColor.setFill()
        UIBezierPath(rect: rect).fill()
        
        for i in 0...(p.days-1) {
            let x = CGFloat(i) * p.dayWidth + p.margin.width
            let r = CGRect(x: x,
                           y: 0,
                           width: p.dayWidth,
                           height: frame.height)
            let lbl = UILabel(frame: r)
            lbl.textAlignment = .center
            lbl.font = lbl.font.withSize(12)
            lbl.textColor = p.legendTextColor
            lbl.text = weekDays[i % 7]
            addSubview(lbl)
        }
    }
    
    
}
