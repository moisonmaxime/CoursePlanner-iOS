//
//  CoursesVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/18/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class CoursesVC: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var selectedTable: UITableView!
    @IBOutlet weak var seacrhBar: UISearchBar!
    var selectedCourses:Array<String> = []
    var searchedCourses:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seacrhBar.delegate = self
        searchTable.dataSource = self
        selectedTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == searchTable) {
            return searchedCourses.count
        } else {
            return selectedCourses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == searchTable) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = searchedCourses[indexPath.row]
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = selectedCourses[indexPath.row]
            return cell
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if ((seacrhBar.text?.underestimatedCount)! >= 2) {
            RestAPI.searchCourseIDs(id: searchBar.text!, completion: { (result, err) in
                self.searchedCourses = result!
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
            })
        } else {
            self.searchedCourses = []
            self.searchTable.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        if (tableView == searchTable) {
            print("1")
            selectedCourses.append(searchedCourses[indexPath.row])
        } else {
            selectedCourses.remove(at: indexPath.row)
        }
        selectedTable.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
