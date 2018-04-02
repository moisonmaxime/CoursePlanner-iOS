//
//  CalendarView.swift
//  WeekCalendar
//
//  Created by Maxime Moison on 2/6/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

@IBDesignable class CalendarView: UIScrollView, UIScrollViewDelegate {
    
    // - IBDesignable values to use in storyboard
    @IBInspectable var startHour:Int = 7
    @IBInspectable var endHour:Int = 19
    @IBInspectable var days:Int = 7
    @IBInspectable var hourColor:UIColor = UIColor.gray
    @IBInspectable var dayColor:UIColor = UIColor.gray
    @IBInspectable var legendColor:UIColor = UIColor.white
    @IBInspectable var legendTextColor:UIColor = UIColor.black
    @IBInspectable var scrollable:Bool = true
    
    // - private variables for shaping the calendar
    var hourHeight:CGFloat = CGFloat()
    var dayWidth:CGFloat = CGFloat()
    
    // Frames for labels
    let margin:CGSize = CGSize(width: 40, height: 32)
    
    // - Dispatch group to block some functions until element is drawn
    private let dispatchGroup = DispatchGroup()
    
    // - event views displayed
    private var eventViews:Array<EventView> = Array<EventView>()
    
    private var grid:GridView!
    private var hoursMarks:HoursView!
    private var daysMarks:DaysView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hoursMarks.transform = CGAffineTransform(translationX: scrollView.contentOffset.x, y: 0)
        daysMarks.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
    }
    
    
    
    override func draw(_ rect: CGRect) {
        
        for v in eventViews {
            v.removeFromSuperview()
        }
        eventViews.removeAll()
        
        dispatchGroup.enter()
        
        hourHeight = (frame.height - margin.height) / CGFloat(endHour - startHour)
        dayWidth = (frame.width - margin.width) / CGFloat(days)
        if scrollable {
            hourHeight = max((frame.height - margin.height) / CGFloat(6), hourHeight)
            dayWidth = max((frame.width - margin.width) / CGFloat(3), dayWidth)
        }
        
        let scheduleFrame = CGRect(x: rect.origin.x + margin.width,
                                   y: rect.origin.y + margin.height,
                                   width: CGFloat(days)*dayWidth,
                                   height: CGFloat(endHour - startHour)*(hourHeight))
        contentSize = CGSize(width: margin.width + scheduleFrame.width,
                             height: margin.height + scheduleFrame.height)
        
        let hoursFrame = CGRect(x: 0,
                                y: margin.height,
                                width: margin.width,
                                height: scheduleFrame.height)
        
        let daysFrame = CGRect(x: 0,
                               y: 0,
                               width: scheduleFrame.width + margin.width,
                               height: margin.height)
        
        
        if (grid == nil) {
            grid = GridView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: contentSize.width,
                                          height: contentSize.height))
            addSubview(grid)
        }
        
        if (hoursMarks == nil) {
            hoursMarks = HoursView(frame: hoursFrame)
            insertSubview(hoursMarks, aboveSubview: grid)
        }
        
        if (daysMarks == nil) {
            daysMarks = DaysView(frame: daysFrame)
            insertSubview(daysMarks, aboveSubview: hoursMarks)
        }
        
        dispatchGroup.leave()
    }
    
    func addEvent(day: Int, start: String, end: String, color: UIColor, name: String) {
        dispatchGroup.notify(queue: .main) {
            
            let from = start.timeToDecimal() - Double(self.startHour)
            let to = end.timeToDecimal() - Double(self.startHour)
            let r = CGRect(x: self.margin.width + CGFloat(day) * self.dayWidth,
                           y: self.margin.height + 6 + CGFloat(from) * self.hourHeight,
                           width: self.dayWidth,
                           height: CGFloat(to-from) * (self.hourHeight))
            let event = UINib(nibName: "EventView", bundle: nil)
                .instantiate(withOwner: nil, options: nil)[0] as! EventView
            event.setup(frame: r, color: color, start: start.time24toAmPm(), name: name)
            self.eventViews.append(event)
            self.insertSubview(event, belowSubview: self.hoursMarks)
        }
    }
}


