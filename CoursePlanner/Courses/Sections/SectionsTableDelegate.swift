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
        let attached = sections[indexPath.row]["attached_crn"] as? String
        let lecture = sections[indexPath.row]["lecture_crn"] as? String
        
        var statusChanged = false
        
        if (attached != nil) {
            if let index = courseVC.badCRNs.index(of: attached!) {
                courseVC.badCRNs.remove(at: index)
                statusChanged = true
            }
        }
        
        if (lecture != nil) {
            if let index = courseVC.badCRNs.index(of: lecture!) {
                courseVC.badCRNs.remove(at: index)
                statusChanged = true
            }
        }
        
        
        if let index = courseVC.badCRNs.index(of: crn) {
            courseVC.badCRNs.remove(at: index)
        } else {
            if (!statusChanged) {
                courseVC.badCRNs.append(crn)
            }
        }
        
        self.sectionTable.reloadData()
    }
}
