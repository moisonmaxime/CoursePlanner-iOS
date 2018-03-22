//
//  CoursesSearchBarDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

extension CoursesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if ((seacrhBar.text?.underestimatedCount)! >= 2) {
            RestAPI.searchCourseIDs(id: searchBar.text!, term: self.term, completion: { (result, err) in
                if (err != nil) {
                    DispatchQueue.main.async {
                        self.handleError(error: err!)
                        return
                    }
                }
                
                self.searchedCourses = result!.sorted(by: { (s1, s2) -> Bool in
                    let s1 = s1.split(separator: "-")
                    let s2 = s2.split(separator: "-")
                    
                    if (s1[0] == s2[0]) {
                        let n1 = Int(s1[1]) ?? 0
                        let n2 = Int(s2[1]) ?? 0
                        return n1 < n2
                    }
                    return s1[0] < s2[0]
                })
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
            })
        } else {
            self.searchedCourses = []
            self.searchTable.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = true
    }
}
