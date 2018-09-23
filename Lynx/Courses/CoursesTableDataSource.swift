//
//  CoursesTableViewDataSource.swift
//  Lynx
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension CoursesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // setup the number of rows in each table
        if tableView == searchTable {
            return searchedCourses.count
        } else {
            return selectedCourses.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuickCourseCell") as? QuickCourseCell else { return UITableViewCell() }
        cell.selectionStyle = .none // no selection style
        let course = tableView == searchTable ? searchedCourses[indexPath.row] : selectedCourses[indexPath.row]
        cell.nameLabel.text = course.name
        cell.descriptionLabel.text = course.description
        if tableView == searchTable { cell.setSelected(selectedCourses.contains(course), animated: false) } // update status
        cell.updateView(hasDetails: tableView == selectedTable)
        return cell
    }
}
