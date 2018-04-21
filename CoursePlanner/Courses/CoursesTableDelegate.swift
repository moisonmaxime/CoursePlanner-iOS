//
//  CoursesTableDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension CoursesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == searchTable) {
            let course = searchedCourses[indexPath.row]
            if !removeCourse(course) {
                selectedCourses.append(course)
            }
            let cell = searchTable.cellForRow(at: indexPath) as! QuickCourseCell
            cell.setSelected(selectedCourses.contains(course), animated: false)
            cell.updateView()
            selectedTable.reloadData()
        } else {
            let destination = (storyboard?.instantiateViewController(withIdentifier: "Sections"))! as! SectionsVC
            destination.course = selectedCourses[indexPath.row]
            destination.sectionsDelegate = self
            destination.term = term
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
