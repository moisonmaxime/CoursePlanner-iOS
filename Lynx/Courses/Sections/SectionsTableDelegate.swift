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
        
        let crn = sections[indexPath.row].crn
        let attached = sections[indexPath.row].attachedCourse
        let lecture = sections[indexPath.row].lecture
        let dependents = sections[indexPath.row].dependents
        
        if (attached != nil) {
            if sectionsDelegate.removeCRN(attached!) {
            } else {
                sectionsDelegate.addCRN(attached!)
            }
        }

        if let lecture = lecture {
            _ = sectionsDelegate.removeCRN(lecture)
        }
        
        if !sectionsDelegate.removeCRN(crn) {
            sectionsDelegate.addCRN(crn)
            for dependent in dependents {
                sectionsDelegate.addCRN(dependent)
            }
        } else {
            for dependent in dependents {
                _ = sectionsDelegate.removeCRN(dependent)
            }
        }
        
        let mainCell = sectionTable.cellForRow(at: indexPath) as? CourseCell
        mainCell?.updateAvailability(sectionsDelegate.getBadCRNs())
        mainCell?.updateView()
        
        updateAvailability(for: attached)
        updateAvailability(for: lecture)
        
        for dependent in dependents {
            updateAvailability(for: dependent)
        }
    }
    
    func updateAvailability(for crn: String?) {
        guard crn != nil else {
            return
        }
        if let indexFound = sections.index(where: { (section) -> Bool in return section.crn == crn }) {
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
