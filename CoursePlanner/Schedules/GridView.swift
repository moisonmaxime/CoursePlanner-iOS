//
//  CalendarGridView.swift
//  WeekCalendar
//
//  Created by Maxime Moison on 2/10/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

internal class GridView: UIView {
    
    private var p:CalendarView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        p = superview! as! CalendarView
        p.backgroundColor?.setFill()
        UIBezierPath(rect: rect).fill()
        drawVerticalLines(rect: rect)
        drawHorizontalLines(rect: rect)
    }
    
    private func drawHorizontalLines(rect: CGRect) {
        let hours = p.endHour - p.startHour
        if (hours > 0) {
            for i in 0...(hours-1) {
                let x1 = rect.minX + p.margin.width
                let x2 = rect.maxX
                let y = rect.minY + p.hourHeight * CGFloat(i) + p.margin.height + 6
                let path = UIBezierPath()
                path.move(to: CGPoint(x: x1, y: y))
                path.addLine(to: CGPoint(x: x2, y: y))
                p.hourColor.setStroke()
                path.lineWidth = 0.5
                path.stroke()
            }
        }
    }
    
    private func drawVerticalLines(rect: CGRect) {
        if (p.days > 1) {
            for i in 1...(p.days-1) {
                let y1 = rect.minY + p.margin.height
                let y2 = rect.maxY
                let x = rect.minX + p.dayWidth * CGFloat(i) + p.margin.width
                let path = UIBezierPath()
                path.move(to: CGPoint(x: x, y: y1))
                path.addLine(to: CGPoint(x: x, y: y2))
                p.dayColor.setStroke()
                path.stroke()
            }
        }
    }

}
