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
        
        // deal with adding/removing from badCRNs accordingly
        
        let crn = sections[indexPath.row].crn
        
        let isRemoving = sectionsDelegate.removeCRN(crn)
        if !isRemoving { sectionsDelegate.addCRN(crn) }
        
        updateAvailability(for: crn)
        
        if let attached = sections[indexPath.row].attachedCourse {
            if isRemoving {
                _ = sectionsDelegate.removeCRN(attached)
            } else {
                sectionsDelegate.addCRN(attached)
            }
            updateAvailability(for: attached)
        }

        if let lecture = sections[indexPath.row].lecture {
            if isRemoving {
                _ = sectionsDelegate.removeCRN(lecture)
            }
            updateAvailability(for: lecture)
        }

        for dependent in sections[indexPath.row].dependents {
            if isRemoving {
                _ = sectionsDelegate.removeCRN(dependent)
            } else {
                sectionsDelegate.addCRN(dependent)
            }
            updateAvailability(for: dependent)
        }
    }

    func updateAvailability(for crn: String) {
        if let indexFound = sections.index(where: { (section) -> Bool in return section.crn == crn }) {
            if let cell = sectionTable.cellForRow(at: IndexPath(row: indexFound, section: 0)) as? CourseCell {
                let isAvailable = !sectionsDelegate.getBadCRNs().contains(crn)
                cell.update(isAvailable)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
