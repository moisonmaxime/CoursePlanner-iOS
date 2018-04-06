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
        nameLabel.textColor = isSelected ? .white : .black
        descriptionLabel.textColor = isSelected ? .white : .black
        backgroundColor = isSelected ? .black : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
