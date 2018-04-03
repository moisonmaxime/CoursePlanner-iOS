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
        if (tableView == searchTable) {
            if let index = selectedCourses.index(of: searchedCourses[indexPath.row]) {
                selectedCourses.remove(at: index)
            } else {
                selectedCourses.append(searchedCourses[indexPath.row])
            }
        } else {
            selectedCourses.remove(at: indexPath.row)
        }
        searchTable.reloadData()
        selectedTable.reloadData()
    }
}
