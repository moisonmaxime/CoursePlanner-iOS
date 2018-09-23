//
//  CourseCell.swift
//  Lynx
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
    @IBOutlet weak var seatsLabel: UILabel!

    var section: Section!
    var isAvailable: Bool = true
    var neededCRN: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(section: Section) {
        self.section = section
        courseIDLabel.text = section.courseID
        daysLabel.text = section.days
        hoursLabel.text = section.hours
        instructorLabel.text = section.instructor
        crnLabel.text = section.crn
        let room = section.room == " " ? "TBD" : section.room
        roomLabel.text = room.readableRoom()
        typeLabel.text = section.type
        seatsLabel.text = section.isFull ?
            "FULL\(section.available < 0 ? " (\(-section.available) over enrolled)" : "")"
            : "\(section.available) seat\(section.available < 2 ? "" : "s") available (Out of \(section.capacity))"
        seatsLabel.textColor = section.isFull ? UIColor.red.darker() : .black
        seatsLabel.font = UIFont.systemFont(ofSize: seatsLabel.font.pointSize, weight: section.isFull ? .bold : .regular)
    }

    func updateAvailability(_ badCRNs: [String]) {

        if badCRNs.contains(section.crn) {
            isAvailable = false
        } else {
            isAvailable = true
            neededCRN = nil
        }
    }

    func updateView() {
        let newAlpha: CGFloat = isAvailable ? 1 : 0.2
        courseIDLabel.alpha = newAlpha
        daysLabel.alpha = newAlpha
        hoursLabel.alpha = newAlpha
        instructorLabel.alpha = newAlpha
        crnLabel.alpha = newAlpha
        roomLabel.alpha = newAlpha
        typeLabel.alpha = newAlpha
        seatsLabel.alpha = newAlpha
    }
}
