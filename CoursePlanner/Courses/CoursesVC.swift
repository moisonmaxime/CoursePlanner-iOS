//
//  CoursesVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/18/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class CoursesVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var selectedTable: UITableView!
    @IBOutlet weak var seacrhBar: UISearchBar!
    @IBOutlet weak var termLabel: UILabel!
    
    var term:String?
    
    var selectedCourses:Array<[String: String]> = []
    var searchedCourses:Array<[String: String]> = []
    
    var badCRNs:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = term?.readableTerm()
        
        let nib = UINib.init(nibName: "QuickCourseCell", bundle: nil)
        searchTable.register(nib, forCellReuseIdentifier: "QuickCourseCell")
        selectedTable.register(nib, forCellReuseIdentifier: "QuickCourseCell")
        
        seacrhBar.delegate = self
        searchTable.dataSource = self
        searchTable.delegate = self
        selectedTable.dataSource = self
        selectedTable.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTables() {
        searchTable.reloadData()
        selectedTable.reloadData()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.searchTable.contentInset.bottom = keyboardHeight + 50
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if (segue.identifier == "showSchedules") {
            let VC = segue.destination as! SchedulesVC
            var selectedIDs:[String] = []
            for course in selectedCourses {
                selectedIDs.append(course["name"]!)
            }
            VC.courses = selectedIDs
            VC.term = term!
            VC.badCRNs = badCRNs
        }
     }
}
