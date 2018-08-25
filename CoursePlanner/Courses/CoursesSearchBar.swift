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
        updateClearButton()
    }
    
    @IBAction func searchDidChanged(_ sender: Any) {
        
        updateClearButton()
        if ((searchField.text?.underestimatedCount)! >= 2) {
            let searchPrompt = searchField.text!
            RestAPI.searchCourseIDs(id: searchField.text!,
                                    term: self.term!,
                                    completionHandler: { result in
                                        if (searchPrompt == self.searchField.text!) {
                                            if (result != nil) {
                                                self.searchedCourses = result.sorted(by: { (c1, c2) -> Bool in
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
            }, errorHandler: handleError)
        } else {
            self.searchedCourses = []
            self.searchTable.reloadData()
        }
    }
    @IBAction func searchDidEnd(_ sender: Any) {
        searchTable.isHidden = true
        selectionLabel.isHidden = true
        updateSearchStatus()
        updateClearButton()
    }
    @IBAction func searchDidReturn(_ sender: Any) {
        searchField.endEditing(true)
    }
    
    @IBAction func clearField(_ sender: Any) {
        searchField.text = ""
        updateSearchStatus()
        updateClearButton()
        searchedCourses = []
        searchTable.reloadData()
    }
    
    func updateClearButton() {
        // Update whether clear button is visible or not
        let willHide = searchField.text == "" || !searchField.isEditing
        
        // if already in the settings it's going to be, return
        if ((!willHide && clearSearchButton.alpha == 1) || (willHide && clearSearchButton.alpha == 0)) {
            return
        }
        
        clearSearchButton.transform = CGAffineTransform(translationX: willHide ? 0 : 64, y: 0)
        clearSearchButton.alpha = willHide ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.clearSearchButton.transform = CGAffineTransform(translationX: willHide ? 64 : 0, y: 0)
            self.clearSearchButton.alpha = willHide ? 0 : 1
        }
    }
    
    func updateSearchStatus() {
        // Update search button style
        UIView.animate(withDuration: 0.2, animations: {
            self.searchIcon.transform = self.searchField.isEditing ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.searchIcon.alpha = self.searchField.isEditing ? 1 : 0.4
                self.searchIcon.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
}
