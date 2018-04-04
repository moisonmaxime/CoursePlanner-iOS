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
    var course:[String:Any?]!

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
    }
    
    func checkLecture(_ badCRNs: [String]) {
        if badCRNs.contains(course["lecture_crn"] as? String ?? "") {
            crnLabel.alpha = 0.3
            return
        }
        crnLabel.alpha = 1
    }
    
    func updateView() {
        crnLabel.isHidden = isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
