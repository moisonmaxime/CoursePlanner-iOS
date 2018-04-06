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
    
    var course:[String:Any?]!
    var isAvailable:Bool = true
    var neededCRN:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(course: [String: Any?]) {
        self.course = course
        courseIDLabel.text = course["course_id"] as? String
        daysLabel.text = course["days"] as? String
        hoursLabel.text = course["hours"] as? String
        instructorLabel.text = course["instructor"] as? String
        crnLabel.text = course["crn"] as? String
        let room = course["room"] as? String ?? "TBD"
        roomLabel.text = room.readableRoom()
        typeLabel.text = course["type"] as? String
    }
    
    func updateAvailability(_ badCRNs: [String]) {
        
        if badCRNs.contains(course["crn"] as? String ?? "") {
            isAvailable = false
            neededCRN = course["crn"] as? String
        }else if badCRNs.contains(course["lecture_crn"] as? String ?? "") {
            isAvailable = false
            neededCRN = course["lecture_crn"] as? String
        } else if badCRNs.contains(course["attached_crn"] as? String ?? "") {
            isAvailable = false
            neededCRN = course["attached_crn"] as? String
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
