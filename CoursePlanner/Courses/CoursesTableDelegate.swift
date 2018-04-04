//
//  CoursesTableDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

extension CoursesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if (tableView == searchTable) {
            if let index = selectedCourses.index(of: searchedCourses[indexPath.row]) {
                selectedCourses.remove(at: index)
            } else {
                selectedCourses.append(searchedCourses[indexPath.row])
            }
        } else {
            //selectedCourses.remove(at: indexPath.row)
            let destination = (storyboard?.instantiateViewController(withIdentifier: "Sections"))! as! SectionsVC
            destination.id = selectedCourses[indexPath.row]["name"]
            destination.courseVC = self
            destination.term = term
            self.navigationController?.pushViewController(destination, animated: true)
        }
        searchTable.reloadData()
        selectedTable.reloadData()
    }
}
