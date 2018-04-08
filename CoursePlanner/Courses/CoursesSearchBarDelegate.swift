//
//  CoursesSearchBarDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension CoursesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if ((searchBar.text?.underestimatedCount)! >= 2) {
            let searchPrompt = searchBar.text!
            RestAPI.searchCourseIDs(id: searchBar.text!, term: self.term, completion: { (result, err) in
                DispatchQueue.main.sync {
                    if (err != nil) {
                        self.handleError(error: err!)
                        return
                    }
                    if (searchPrompt == self.searchBar.text!) {
                        if (result != nil) {
                            self.searchedCourses = result!.sorted(by: { (c1, c2) -> Bool in
                                let s1 = c1["name"]!.split(separator: "-")
                                let s2 = c2["name"]!.split(separator: "-")
                                
                                if (s1[0] == s2[0]) {
                                    let n1 = Int(s1[1]) ?? 0
                                    let n2 = Int(s2[1]) ?? 0
                                    return n1 < n2
                                }
                                return s1[0] < s2[0]
                            })
                        } else {
                            self.searchedCourses = []
                        }
                        self.searchTable.reloadData()
                    }
                }
            })
        } else {
            self.searchedCourses = []
            self.searchTable.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = false
        selectionLabel.isHidden = !(selectedCourses.count > 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = true
        selectionLabel.isHidden = true
    }
}
