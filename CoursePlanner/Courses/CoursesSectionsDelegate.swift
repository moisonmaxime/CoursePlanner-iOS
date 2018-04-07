//
//  CoursesSectionsDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

extension CoursesVC: SectionsDelegate {
    func addCRN(_ crn: String) {
        badCRNs.append(crn)
    }
    
    func removeCRN(_ crn: String) -> Bool {
        if let index = badCRNs.index(of: crn) {
            badCRNs.remove(at: index)
            return true
        }
        return false
    }
    
    func removeCourse(_ course: [String : String]) {
        if let index = selectedCourses.index(of: course) {
            selectedCourses.remove(at: index)
        }
    }
    
    func getBadCRNs() -> [String] {
        return badCRNs
    }
}
