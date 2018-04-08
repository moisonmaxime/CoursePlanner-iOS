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
        
        var statusChanged = false
        
        if (attached != nil) {
            if sectionsDelegate.removeCRN(attached!) {
                statusChanged = true
            }
        }
        
        if (lecture != nil) {
            if (sectionsDelegate.removeCRN(lecture!)) {
                statusChanged = true
            }
        }
        
        if !sectionsDelegate.removeCRN(crn) {
            if (!statusChanged) {
                sectionsDelegate.addCRN(crn)
            }
        }
        
        self.sectionTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
