//
//  HomeVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource {
    
    var terms:Array<String> = []
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var termTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termTable.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        termTable.addSubview(refreshControl)
        RestAPI.checkAPIKey { (error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.handleError(error: error!)
                }
            }
        }
        refresh()
    }
    
    @objc func refresh() {
        RestAPI.getTerms { (terms, error) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            if (error != nil) {
                DispatchQueue.main.async {
                    self.handleError(error: error!)
                }
            } else {
                self.terms = terms!
                DispatchQueue.main.async {
                    self.termTable.reloadData();
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = terms[indexPath.row]
        return cell
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
