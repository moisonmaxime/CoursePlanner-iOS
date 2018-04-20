//
//  CoursesSearchBar.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension CoursesVC {
    @IBAction func searchDidBegin(_ sender: Any) {
        searchTable.isHidden = false
        selectionLabel.isHidden = !(selectedCourses.count > 0)
        updateSearchStatus()
    }
    
    @IBAction func searchDidChanged(_ sender: Any) {
        updateSearchStatus()
        if ((searchField.text?.underestimatedCount)! >= 2) {
            let searchPrompt = searchField.text!
            RestAPI.searchCourseIDs(id: searchField.text!, term: self.term, completion: { (result, err) in
                DispatchQueue.main.sync {
                    if (err != nil) {
                        self.handleError(error: err!)
                        return
                    }
                    if (searchPrompt == self.searchField.text!) {
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
    @IBAction func searchDidEnd(_ sender: Any) {
        searchTable.isHidden = true
        selectionLabel.isHidden = true
        updateSearchStatus()
    }
    @IBAction func searchDidReturn(_ sender: Any) {
        searchField.endEditing(true)
    }
    
    @IBAction func clearField(_ sender: Any) {
        searchField.text = ""
        updateSearchStatus()
        searchedCourses = []
        searchTable.reloadData()
    }
    
    func updateSearchStatus() {
        clearSearchButton.isHidden = (searchField.text == "" || !searchField.isEditing)
        searchIcon.alpha = searchField.isEditing ? 1 : 0.4
    }
}
