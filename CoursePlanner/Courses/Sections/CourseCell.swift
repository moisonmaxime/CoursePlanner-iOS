//
//  CourseCell.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/3/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var courseIDLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var crnLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var course:Course!
    var isAvailable:Bool = true
    var neededCRN:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(course: Course) {
        self.course = course
        courseIDLabel.text = course.courseID
        daysLabel.text = course.days
        hoursLabel.text = course.hours
        instructorLabel.text = course.instructor
        crnLabel.text = course.crn
        let room = course.room ?? "TBD"
        roomLabel.text = room.readableRoom()
        typeLabel.text = course.type
    }
    
    func updateAvailability(_ badCRNs: [String]) {
        
        if badCRNs.contains(course.crn) {
            isAvailable = false
        } else if badCRNs.contains(course.lecture ?? "") {
            isAvailable = false
            neededCRN = course.lecture
        } else if badCRNs.contains(course.attachedCourse ?? "") {
            isAvailable = false
            neededCRN = course.attachedCourse
        } else {
            isAvailable = true
            neededCRN = nil
        }
    }
    
    func updateView() {
        let newAlpha:CGFloat = isAvailable ? 1 : 0.2
        courseIDLabel.alpha = newAlpha
        daysLabel.alpha = newAlpha
        hoursLabel.alpha = newAlpha
        instructorLabel.alpha = newAlpha
        crnLabel.alpha = newAlpha
        roomLabel.alpha = newAlpha
        typeLabel.alpha = newAlpha
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
