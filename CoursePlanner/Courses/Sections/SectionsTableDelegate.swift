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
        
        let crn = courses[indexPath.row].crn
        let attached = courses[indexPath.row].attachedCourse
        let lecture = courses[indexPath.row].lecture
        
        if (attached != nil) {
            if sectionsDelegate.removeCRN(attached!) {
            } else {
                sectionsDelegate.addCRN(attached!)
            }
        }
        
        if (lecture != nil) {
            _ = sectionsDelegate.removeCRN(lecture!)
        }
        
        if !sectionsDelegate.removeCRN(crn) {
                sectionsDelegate.addCRN(crn)
        }
        
        self.sectionTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
