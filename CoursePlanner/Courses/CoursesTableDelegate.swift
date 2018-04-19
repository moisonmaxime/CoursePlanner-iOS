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
            if let index = selectedCourses.index(of: searchedCourses[indexPath.row]) {
                selectedCourses.remove(at: index)
            } else {
                selectedCourses.append(searchedCourses[indexPath.row])
            }
        } else {
            let destination = (storyboard?.instantiateViewController(withIdentifier: "Sections"))! as! SectionsVC
            destination.course = selectedCourses[indexPath.row]
            destination.sectionsDelegate = self
            destination.term = term
            self.navigationController?.pushViewController(destination, animated: true)
        }
        reloadTables()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
