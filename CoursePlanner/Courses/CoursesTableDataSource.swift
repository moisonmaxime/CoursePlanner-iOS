//
//  CoursesTableViewDataSource.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

extension CoursesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == searchTable) {
            return searchedCourses.count
        } else {
            return selectedCourses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if (tableView == searchTable) {
            cell.textLabel?.text = searchedCourses[indexPath.row]["name"]
            if (selectedCourses.contains(searchedCourses[indexPath.row])) {
                cell.backgroundColor = .lightGray
            }
        } else {
            cell.textLabel?.text = selectedCourses[indexPath.row]["name"]
        }
        return cell
    }
}
