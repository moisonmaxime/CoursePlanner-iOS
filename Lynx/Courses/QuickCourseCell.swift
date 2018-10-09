//
//  QuickCourseCell.swift
//  Lynx
//
//  Created by Maxime Moison on 4/4/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

struct QuickCourseCellPayload {
    var hasDetails: Bool
    var isSelected: Bool
    var course: CourseSearchResult
}

class QuickCourseCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView() {
        let highlightColor = #colorLiteral(red: 0.07450980392, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
        nameLabel.textColor = isSelected ? .white : highlightColor
        descriptionLabel.textColor = isSelected ? .white : highlightColor
        backgroundColor = isSelected ? highlightColor : .white
    }
}

extension QuickCourseCell: CellLoadable {
    typealias PayloadType = QuickCourseCellPayload

    func load(with payload: QuickCourseCellPayload) {
        nameLabel.text = payload.course.name
        descriptionLabel.text = payload.course.description
        detailsArrow.isHidden = !payload.hasDetails
        setSelected(payload.isSelected, animated: false)
        updateView()
    }
}
