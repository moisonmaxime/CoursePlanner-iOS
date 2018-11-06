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
        if tableView == searchTable {
            return searchCell(for: indexPath.row)
        } else {
            return selectedCell(for: indexPath.row)
        }
    }
    
    func searchCell(for index: Int) -> UITableViewCell {
        guard let cell = searchTable.dequeueReusableCell(withIdentifier: "QuickCourseCell") as? QuickCourseCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none // no selection style
        let course = searchedCourses[index]
        cell.load(with: QuickCourseCellPayload(hasDetails: false,
                                               isSelected: selectedCourses.contains(course),
                                               course: course))
        return cell
    }
    
    func selectedCell(for index: Int) -> UITableViewCell {
        guard let cell = selectedTable.dequeueReusableCell(withIdentifier: "QuickCourseCell") as? QuickCourseCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none // no selection style
        let course = selectedCourses[index]
        cell.load(with: QuickCourseCellPayload(hasDetails: true,
                                               isSelected: false,
                                               course: course))
        return cell
    }
}
