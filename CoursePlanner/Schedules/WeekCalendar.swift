//
//  WeekCalendar.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/1/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

let DAYS:[Character: Int] = ["M": 0, "T": 1, "W": 2, "R": 3, "F": 4]
let COLORS:[UIColor] = [.red, .blue, .green, .orange, .purple]


class WeekCalendar: UIView {
    
    var schedule:Schedule!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if (schedule == nil) {
            return
        }
        
        for v in subviews {
            v.removeFromSuperview()
        }
        
        var colors = COLORS
        
        var start = schedule.earliest
        var end = schedule.latest
        start = Double(Int(start/100)) + Double(Int(start) % 100)/60
        end = Double(Int(end/100)) + Double(Int(end) % 100)/60
        
        let hourHeight:CGFloat = self.frame.height / CGFloat(end-start)
        let dayWidth = self.frame.width / 5
        
        for section in schedule.sections {
            let color = colors.popLast() ?? .lightGray
            for course in section.courses {
                let hours = course.hours
                let days = course.days
                if (hours != nil && hours != "TBD-TBD") {
                    for d in days! {
                        let dayOffset = DAYS[d]
                        let times = hours!.extractTime()
                        let frame = CGRect(
                            x: 1 + CGFloat(dayOffset!) * (dayWidth),
                            y: hourHeight * CGFloat(times.0 - start),
                            width: dayWidth-2,
                            height: hourHeight * CGFloat(times.1 - times.0))
                        let view = UINib(nibName: "Event", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Event
                        view.frame = frame
                        view.courseID.text! = course.courseID
                        view.tintColor = color
                        insertSubview(view, at: 0)
                    }
                }
            }
        }
    }
    
}
