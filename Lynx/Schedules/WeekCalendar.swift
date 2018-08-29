//
//  WeekCalendar.swift
//  Lynx
//
//  Created by Maxime Moison on 4/1/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class WeekCalendar: UIView {
    
    let DAYS:[Character: Int] = ["M": 0, "T": 1, "W": 2, "R": 3, "F": 4]
    let COLORS:[UIColor] = [.red, .blue, .green, .orange, .purple]
    let weekDays:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    var schedule:Schedule!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        for subView in subviews {
            subView.removeFromSuperview()
        }
        
        if (schedule == nil || schedule.sections.count == 0) {
            let noScheduleLabel = UILabel(frame: CGRect(x: 32, y: rect.height/2-50, width: rect.width-64, height: 100))
            noScheduleLabel.text = "No Schedule"
            noScheduleLabel.textColor = .lightGray
            noScheduleLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
            noScheduleLabel.adjustsFontSizeToFitWidth = true
            noScheduleLabel.textAlignment = .center
            insertSubview(noScheduleLabel, at: 0)
            return
        }
        
        let daysFrame = CGRect(x: 42, y: 10, width: rect.width - 52, height: 20)
        let timesFrame = CGRect(x: 10, y: 30, width: 32, height: rect.height - 40)
        let scheduleFrame = CGRect(x: 42, y: 30, width: rect.width - 52, height: rect.height - 40)
        
        drawCourses(scheduleFrame)
        drawDays(daysFrame)
        drawTimes(timesFrame)
    }
    
    func drawDays(_ rect: CGRect) {
        let dayWidth = rect.width/5
        for dayOffset in 0..<5 {
            let dayFrame = CGRect(x: rect.minX + dayWidth * CGFloat(dayOffset), y: rect.minY, width: dayWidth, height: rect.height)
            let lbl = UILabel(frame: dayFrame)
            lbl.text = weekDays[dayOffset]
            lbl.font = UIFont.boldSystemFont(ofSize: 15)
            lbl.adjustsFontSizeToFitWidth = true
            lbl.textAlignment = .center
            insertSubview(lbl, at: 0)
        }
    }
    
    func drawTimes(_ rect: CGRect) {
        
        let startOffset = CGFloat(Int(schedule.earliest) % 100)/60
        let skipFirst = startOffset != 0
        let start = Int(schedule.earliest/100) + (skipFirst ? 1 : 0)
        let end = Int(schedule.latest/100)
        let duration:Double = Double(Int(schedule.latest/100)) + Double(Int(schedule.latest) % 100)/60 - Double(Int(schedule.earliest/100)) - Double(Int(schedule.earliest) % 100)/60
        let timeSpacing = rect.height/CGFloat(duration)
        
        for timeOffset in start...end {
            let timeFrame = CGRect(x: rect.minX, y: rect.minY-8 + (CGFloat(timeOffset-start) + startOffset) * timeSpacing, width: rect.width, height: 16)
            let lbl = UILabel(frame: timeFrame)
            let hour = timeOffset == 12 ? 12 : timeOffset % 12
            lbl.text = "\(hour):00\(timeOffset/12==1 ? "pm" : "am")"
            lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
            lbl.adjustsFontSizeToFitWidth = true
            lbl.textAlignment = .left
            insertSubview(lbl, at: 0)
        }
        
        /*
         let timeFrame = CGRect(x: rect.minX, y: rect.minY-8 + CGFloat(i) * timeSpacing, width: rect.width, height: 16)
         let lbl = UILabel(frame: timeFrame)
         var time = Int(i/60) + Int(Double(start)*0.01)
         let isPM = time/12 == 1
         time = time == 12 ? 12 : time % 12
         lbl.text = "\(time):00\(isPM ? "pm" : "am")"
         lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
         lbl.adjustsFontSizeToFitWidth = true
         lbl.textAlignment = .left
         insertSubview(lbl, at: 0)
         */
        
    }
    
    func drawCourses(_ rect: CGRect) {
        var colors = COLORS
        
        var start = schedule.earliest
        var end = schedule.latest
        start = Double(Int(start/100)) + Double(Int(start) % 100)/60
        end = Double(Int(end/100)) + Double(Int(end) % 100)/60
        
        let hourHeight:CGFloat = rect.height / CGFloat(end-start)
        let dayWidth = rect.width / 5
        
        for course in schedule.courses {
            let color = colors.popLast() ?? .lightGray
            for section in course {
                let hours = section.hours
                let days = section.days
                if hours != "TBD-TBD" {
                    for day in days {
                        let dayOffset = DAYS[day]
                        let times = hours.extractTime()
                        let frame = CGRect(
                            x: rect.minX + 1 + CGFloat(dayOffset!) * (dayWidth),
                            y: rect.minY + hourHeight * CGFloat(times.0 - start),
                            width: dayWidth-2,
                            height: hourHeight * CGFloat(times.1 - times.0))
                        if let view = UINib(nibName: "Event", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? Event {
                            view.frame = frame
                            view.courseID.text = section.shortName
                            view.typeLabel.text = "\(section.type) \(section.sectionID)"
                            view.tintColor = color
                            view.alpha = section.isFull ? 0.4 : 1
                            insertSubview(view, at: 0)
                        }
                    }
                }
            }
        }
    }
    
}
