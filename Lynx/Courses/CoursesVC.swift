//
//  CoursesVC.swift
//  Lynx
//
//  Created by Maxime Moison on 3/18/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class CoursesVC: UIViewController {
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var selectedTable: UITableView!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!

    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var clearSearchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var emptyCoursesPrompt: UIImageView!

    var timer: Timer?

    // If user changes term, then update UI and reset everything
    var term: String = "" {
        didSet {
            self.selectedCourses = []
            self.searchedCourses = []
            self.badCRNs = []
            self.termButton.setTitle(term.readableTerm(), for: .normal)
            self.reloadTables()
            self.searchField.text = ""
        }
    }

    // when searching for courses when courses are selected or deselected give a number of courses selected
    var selectedCourses: [CourseSearchResult] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let count = strongSelf.selectedCourses.count
                strongSelf.selectionLabel.isHidden = count == 0 || strongSelf.searchTable.isHidden
                strongSelf.selectionLabel.text = "\(count) course\(count > 1 ? "s" : "") selected"
                strongSelf.searchTable.contentInset.top = count > 0 ? 24 : 0
                strongSelf.updateEmptyCoursesPrompt()
            }
        }
    }

    var searchedCourses: [CourseSearchResult] = []
    var badCRNs: [String] = []   // Track the CRNs to not include in the schedule building

    override func viewDidLoad() {
        super.viewDidLoad()
        
        termButton.setCornerRadius(at: 5)
        buildButton.setCornerRadius(at: 5)

        if let lastTerm = UserSettings.defaultTerm {
            self.term = lastTerm
        } else {
            navigationController?.didStartLoading()
            RestAPI.getTerms(completionHandler: { [weak self] (terms) in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.didFinishLoading()
                strongSelf.term = terms.first ?? ""
                UserSettings.defaultTerm = strongSelf.term
            }, errorHandler: handleError)
        }

        // Add the QuickCourseCell reusable to the tables
        let nib = UINib.init(nibName: "QuickCourseCell", bundle: nil)
        searchTable.register(nib, forCellReuseIdentifier: "QuickCourseCell")
        selectedTable.register(nib, forCellReuseIdentifier: "QuickCourseCell")

        // the clear button has to be outside of screen at start
        updateClearButton()

        // Set delegates
        searchTable.dataSource = self
        searchTable.delegate = self
        selectedTable.dataSource = self
        selectedTable.delegate = self

        // Add an observer to check on keyboard status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    deinit {
        // When deinit, remove observer...
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reloadTables() {
        searchTable.reloadData()
        selectedTable.reloadData()
    }

    func updateEmptyCoursesPrompt() {
        emptyCoursesPrompt.isHidden = selectedCourses.count != 0
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        // When keyboard shows, change inset in searchTable so that nothing is under keyboard
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.searchTable.contentInset.bottom = keyboardHeight + 50
        }
    }

    @IBAction func termPress(_ sender: Any) {
        // Term selection
        RestAPI.getTerms(completionHandler: { [weak self] terms in
            guard let strongSelf = self else { return }

            let termSelector = UIAlertController(title: "Choose a term", message: nil, preferredStyle: .actionSheet)

            for term in terms {
                termSelector.addAction(.init(title: term.readableTerm(), style: .default, handler: { _ in
                    if term != strongSelf.term {
                        strongSelf.term = term
                        UserSettings.defaultTerm = term
                    }
                }))
            }

            termSelector.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            strongSelf.present(termSelector, animated: true, completion: nil)
        }, errorHandler: handleError)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSchedules" {
            if let destination = segue.destination as? SchedulesVC {
                var selectedIDs: [String] = []
                for course in selectedCourses {
                    selectedIDs.append(course.name)
                }
                destination.courses = selectedIDs
                destination.term = term
                destination.badCRNs = badCRNs
            }
        } else if segue.identifier == "showSaved" {
            if let dest = segue.destination as? SavedSchedulesVC {
                dest.term = term
            }
        }
    }
}

