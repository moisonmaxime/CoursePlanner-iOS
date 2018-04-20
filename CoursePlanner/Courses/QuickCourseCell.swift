//
//  QuickCourseCell.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/4/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class QuickCourseCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateView() {
        let highlightColor = #colorLiteral(red: 0.07450980392, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
        nameLabel.textColor = isSelected ? .white : highlightColor
        descriptionLabel.textColor = isSelected ? .white : highlightColor
        backgroundColor = isSelected ? highlightColor : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
