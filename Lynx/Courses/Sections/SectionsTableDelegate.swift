//
//  SectionsTableDelegate.swift
//  Lynx
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
        
        let mainCell = sectionTable.cellForRow(at: indexPath) as! CourseCell
        mainCell.updateAvailability(sectionsDelegate.getBadCRNs())
        mainCell.updateView()
        
        updateAvailability(for: attached)
        updateAvailability(for: lecture)
        
        if (dependents != nil) {
            for dependent in dependents! {
                updateAvailability(for: dependent)
            }
        }
    }
    
    func updateAvailability(for crn: String?) {
        guard crn != nil else {
            return
        }
        if let indexFound = courses.index(where: { (course) -> Bool in return course.crn == crn }) {
            if let cell = sectionTable.cellForRow(at: IndexPath(row: indexFound, section: 0)) as? CourseCell {
                cell.updateAvailability(sectionsDelegate.getBadCRNs())
                cell.updateView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
