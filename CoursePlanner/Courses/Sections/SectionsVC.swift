//
//  SectionsVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/3/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class SectionsVC: UIViewController {
    
    var courseVC:CoursesVC!
    var sections:[[String: Any?]] = []
    var id:String?
    var term:String?
    @IBOutlet weak var sectionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTable.dataSource = self
        RestAPI.getSections(term: term!, id: id!) { (response, err) in
            if (err != nil) {
                DispatchQueue.main.async {
                    self.handleError(error: err!)
                }
            }
            self.sections = response ?? []
            DispatchQueue.main.async {
                self.sectionTable.reloadData()
            }
        }
        // Do any additional setup after loading the view.
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
    
}
