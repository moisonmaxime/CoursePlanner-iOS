//
//  SectionsVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/3/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol SectionsDelegate {
    func addCRN(_ crn: String)
    func removeCRN(_ crn: String) -> Bool
    func removeCourse(_ course: [String:String])
    func getBadCRNs() -> [String]
}

class SectionsVC: UIViewController {
    
    var sectionsDelegate:SectionsDelegate!
    var courses:[Course] = []
    var course:[String: String]!
    var term:String?
    @IBOutlet weak var sectionTable: UITableView!
    @IBOutlet weak var termLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = term?.readableTerm()
        sectionTable.dataSource = self
        sectionTable.delegate = self
        
        let nib = UINib.init(nibName: "CourseCell", bundle: nil)
        self.sectionTable.register(nib, forCellReuseIdentifier: "CourseCell")
        (self.navigationController as! NavigationController).didStartLoading(immediately: true)
        RestAPI.getSections(term: term!, id: course!["name"]!) { (response, err) in
            DispatchQueue.main.async {
                (self.navigationController as! NavigationController).didFinishLoading()
                if (err != nil) {
                    self.handleError(error: err!)
                }
                self.courses = response ?? []
                self.sectionTable.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func remove(_ sender: Any) {
        sectionsDelegate.removeCourse(course)
        navigationController?.popViewController(animated: true)
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
