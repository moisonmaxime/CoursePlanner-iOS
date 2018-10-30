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
                strongSelf.searchTable.contentInset.top = count > 0 ? 32 : 0
                strongSelf.updateEmptyCoursesPrompt()
            }
        }
    }

    var timer: Timer?
    var searchedCourses: [CourseSearchResult] = []
    var badCRNs: [String] = []   // Track the CRNs to not include in the schedule building
    var settings: ScheduleSearchOptions = ScheduleSearchOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        termButton.setCornerRadius(at: 5)
        buildButton.setCornerRadius(at: 5)
        selectionLabel.setCornerRadius(at: 5)

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

    @IBAction func termTap() {
        // Term selection
        dismissKeyboard()
        if let terms = UserSettings.availableTerms {
            displayTermPicker(terms)
        } else {
            navigationController?.didStartLoading()
            RestAPI.getTerms(completionHandler: { [weak self] terms in
                self?.navigationController?.didFinishLoading()
                self?.displayTermPicker(terms)
                }, errorHandler: handleError)
        }
    }
    
    @IBAction func scheduleOptionsTap() {
        let optionPicker = SchedulesOptionsModalView(settings: settings) { [weak self] (action, settings) in
            self?.settings = settings
            switch (action) {
            case .build :
                self?.performSegue(withIdentifier: "showSchedules", sender: nil)
            case .save:
                self?.performSegue(withIdentifier: "showSaved", sender: nil)
            case .dismiss:
                return
            }
        }
        optionPicker.modalPresentationStyle = .overCurrentContext
        present(optionPicker, animated: false, completion: nil)
    }
    
    private func displayTermPicker(_ terms: [String]) {
        let terms = terms.filter({ [weak self] termToCheck in
            termToCheck != self?.term ?? ""
        })
        
        let termPicker = TermPicker(currentTerm: term, terms: terms, completionHandler: { [weak self] newTerm in
            if let newTerm = newTerm {
                self?.term = newTerm
            }
        })
        termPicker.modalPresentationStyle = .overCurrentContext
        present(termPicker, animated: false, completion: nil)
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
                destination.settings = settings
            }
        } else if segue.identifier == "showSaved" {
            if let dest = segue.destination as? SavedSchedulesVC {
                dest.term = term
            }
        }
    }
}

