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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuickCourseCell") as? QuickCourseCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none // no selection style
        let isSearchTable = tableView == searchTable
        let course = isSearchTable ? searchedCourses[indexPath.row] : selectedCourses[indexPath.row]
        let isSelected = isSearchTable ? selectedCourses.contains(course) : false
        let hasDetails = !isSearchTable

        cell.load(with: QuickCourseCellPayload(hasDetails: hasDetails,
                                               isSelected: isSelected,
                                               course: course))
        return cell
    }
}
