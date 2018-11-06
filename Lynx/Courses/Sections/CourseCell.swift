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
    @IBOutlet weak var finalLabel: UILabel!
    
    private var section: Section!
    private var isAvailable: Bool = true
    
    func update(_ isAvailable: Bool) {
        self.isAvailable = isAvailable
        updateView()
    }
    
    private func updateView() {
        let newAlpha: CGFloat = isAvailable ? 1 : 0.2
        DispatchQueue.main.async { [weak self] in
            self?.alpha = newAlpha
        }
    }
}

extension CourseCell: CellLoadable {
    typealias PayloadType = (section: Section, isAvailable: Bool)
    
    func load(with payload: PayloadType) {
        self.section = payload.section
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
        finalLabel.text = ""
        if let finalDays = section.finalDays,
            let finalHours = section.finalHours {
            finalLabel.text = "Final \(finalDays) \(finalHours)"
        }
        update(payload.isAvailable)
    }
}
