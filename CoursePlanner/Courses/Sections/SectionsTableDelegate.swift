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
        
        let crn = courses[indexPath.row].crn
        let attached = courses[indexPath.row].attachedCourse
        let lecture = courses[indexPath.row].lecture
        let dependents = courses[indexPath.row].dependents
        
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
            if (dependents != nil) {
                for dependent in dependents! {
                    sectionsDelegate.addCRN(dependent)
                }
            }
        } else {
            if (dependents != nil) {
                for dependent in dependents! {
                    _ = sectionsDelegate.removeCRN(dependent)
                }
            }
        }
        
        self.sectionTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
