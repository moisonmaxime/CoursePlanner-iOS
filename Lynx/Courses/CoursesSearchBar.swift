//
//  CoursesSearchBar.swift
//  Lynx
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

        guard let searchPrompt = searchField.text,
            searchPrompt.count >= 2 else {
                self.searchedCourses = []
                self.searchTable.reloadData()
                timer?.invalidate()
                return
        }

        timer?.invalidate()

        timer = Timer(timeInterval: 0.25, repeats: false, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            RestAPI.searchCourseIDs(id: searchPrompt,
                                    term: strongSelf.term,
                                    completionHandler: { [weak strongSelf] result in
                                        strongSelf?.searchedCourses = result
                                        strongSelf?.searchTable.reloadData()
            }, errorHandler: strongSelf.handleError)
        })

        if let timer = timer {
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
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
        if (!willHide && clearSearchButton.alpha == 1) || (willHide && clearSearchButton.alpha == 0) {
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
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.searchIcon.alpha = self.searchField.isEditing ? 1 : 0.4
                self.searchIcon.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
}
