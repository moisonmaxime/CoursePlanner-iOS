//
//  HomeVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    var terms:Array<String> = []
    var refreshControl: UIRefreshControl!
    var selectedRow = ""
    @IBOutlet weak var termTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termTable.dataSource = self
        refreshControl = UIRefreshControl()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showBuilder") {
            let dest = segue.destination as! CoursesVC
            dest.term = selectedRow
        }
    }
    
}
