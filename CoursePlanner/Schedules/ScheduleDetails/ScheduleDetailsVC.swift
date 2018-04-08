//
//  ScheduleDetailsVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol ScheduleDetailsDelegate {
    func getSchedule() -> Schedule
    func getTerm() -> String
}

class ScheduleDetailsVC: UIViewController {
    
    @IBOutlet weak var coursesTable: UITableView!
    var detailDelegate:ScheduleDetailsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "CourseCell", bundle: nil)
        self.coursesTable.register(nib, forCellReuseIdentifier: "CourseCell")
        // Do any additional setup after loading the view.
        coursesTable.dataSource = self
        coursesTable.delegate = self
        coursesTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func register(_ sender: Any) {
        
    }
    
    @IBAction func saveSchedule(_ sender: Any) {
        RestAPI.saveSchedule(term: detailDelegate.getTerm(), crns: detailDelegate.getSchedule().crns) { (err) in
            DispatchQueue.main.async {
                self.handleError(error: err!)
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
