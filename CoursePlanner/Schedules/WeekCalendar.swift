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
        
        var start = schedule.info["earliest"] as! Double
        var end = schedule.info["latest"] as! Double
        start = Double(Int(start/100)) + Double(Int(start) % 100)/60
        end = Double(Int(end/100)) + Double(Int(end) % 100)/60
        
        let hourHeight:CGFloat = self.frame.height / CGFloat(end-start)
        let dayWidth = self.frame.width / 5
        
        for subject in schedule.classes.values {
            let color = colors.popLast() ?? .lightGray
            for course in subject.values {
                let hours = course["hours"] as! String
                let days = course["days"] as! String
                for d in days {
                    let dayOffset = DAYS[d]
                    let times = hours.extractTime()
                    let frame = CGRect(
                        x: CGFloat(dayOffset!) * (dayWidth),
                        y: hourHeight * CGFloat(times["start"]! - start),
                        width: dayWidth,
                        height: hourHeight * CGFloat(times["end"]! - times["start"]!))
                    let view = UINib(nibName: "Event", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Event
                    view.frame = frame
                    view.courseID.text! = course["course_id"] as! String
                    view.time.text = hours
                    insertSubview(view, at: 0)
                    let path = UIBezierPath(rect: frame)
                    color.setFill()
                    path.fill()
                }
            }
        }
    }
    
}
