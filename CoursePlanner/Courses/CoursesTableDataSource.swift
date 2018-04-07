//
//  CoursesTableViewDataSource.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuickCourseCell") as! QuickCourseCell
        cell.selectionStyle = .none
        if (tableView == searchTable) {
            let course = searchedCourses[indexPath.row]
            cell.nameLabel.text = course["name"]
            cell.descriptionLabel.text = course["description"]
            cell.setSelected(selectedCourses.contains(course), animated: false)
            cell.updateView()
        } else {
            let course = selectedCourses[indexPath.row]
            cell.nameLabel.text = course["name"]
            cell.descriptionLabel.text = course["description"]
        }
        return cell
    }
}
