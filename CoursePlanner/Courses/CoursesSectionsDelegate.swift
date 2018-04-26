//
//  CoursesSectionsDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

extension CoursesVC: SectionsDelegate {
    func addCRN(_ crn: String) {
        // If crn is not in list add it
        if (badCRNs.index(of: crn) == nil) {
            badCRNs.append(crn)
        }
    }
    
    func removeCRN(_ crn: String) -> Bool {
        // If crn in list, remove it and return true, else return false
        if let index = badCRNs.index(of: crn) {
            badCRNs.remove(at: index)
            return true
        }
        return false
    }
    
    func removeCourse(_ course: [String : String]) -> Bool {
        // If course is selected, remove it and reset badCRNs
        if let index = selectedCourses.index(of: course) {
            selectedCourses.remove(at: index)
            reloadTables()
            selectionLabel.isHidden = true
            badCRNs = []
            return true
        }
        return false
    }
    
    func getBadCRNs() -> [String] {
        // Get the list of bad crns
        return badCRNs
    }
}
