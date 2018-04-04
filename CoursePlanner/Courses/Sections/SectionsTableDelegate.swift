//
//  SectionsTableDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/3/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension SectionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionTable.deselectRow(at: indexPath, animated: false)
        let crn = sections[indexPath.row]["crn"] as! String
        if let index = courseVC.badCRNs.index(of: crn) {
            courseVC.badCRNs.remove(at: index)
        } else {
            courseVC.badCRNs.append(crn)
        }
        
        self.sectionTable.reloadData()
    }
}
