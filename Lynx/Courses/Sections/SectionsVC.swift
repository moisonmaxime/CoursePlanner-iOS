//
//  SectionsVC.swift
//  Lynx
//
//  Created by Maxime Moison on 4/3/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol SectionsDelegate: class {
    func addCRN(_ crn: String)
    func removeCRN(_ crn: String) -> Bool
    func removeCourse(_ course: CourseSearchResult) -> Bool
    func getBadCRNs() -> [String]
}

class SectionsVC: UIViewController {

    weak var sectionsDelegate: SectionsDelegate!
    var sections: [Section] = []
    var course: CourseSearchResult!
    var term: String?
    @IBOutlet weak var sectionTable: UITableView!
    @IBOutlet weak var termLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = term?.readableTerm()
        sectionTable.dataSource = self
        sectionTable.delegate = self

        let nib = UINib.init(nibName: "CourseCell", bundle: nil)
        self.sectionTable.register(nib, forCellReuseIdentifier: "CourseCell")

        self.navigationController?.didStartLoading(immediately: true)
        RestAPI.getSections(term: term!, id: course.name, completionHandler: { sections in
            self.navigationController?.didFinishLoading()
            self.sections = sections
            self.sectionTable.reloadData()
        }, errorHandler: handleError)
        // Do any additional setup after loading the view.
    }

    @IBAction func remove(_ sender: Any) {
        _ = sectionsDelegate.removeCourse(course)
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
