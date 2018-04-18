//
//  TermCell.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/4/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class TermCell: UITableViewCell {

    @IBOutlet weak var termLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView() {
        termLabel.font = UIFont.systemFont(ofSize: termLabel.font.pointSize,
                                           weight: (isSelected ? .bold : .thin))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        updateView()
    }
    
}
