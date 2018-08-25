//
//  HomeVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/14/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet var displayButtons: [UIButton]!
    var terms:Array<String> = []
    var refreshControl: UIRefreshControl!
    var selectedRow: String? {
        didSet {
            for b in displayButtons {
                b.isEnabled = (selectedRow != nil)
            }
        }
    }
    @IBOutlet weak var termTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termTable.dataSource = self
        termTable.delegate = self
        (self.navigationController as! NavigationController).didFinishLoading()
        
        let nib = UINib.init(nibName: "TermCell", bundle: nil)
        termTable.register(nib, forCellReuseIdentifier: "TermCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        termTable.addSubview(refreshControl)
        refresh()
    }
    
    @objc func refresh() {
        selectedRow = nil
        RestAPI.getTerms(completionHandler: { terms in
            self.terms = terms.sorted(by: { (s1, s2) -> Bool in
                let t1 = s1.readableTerm().split(separator: " ")
                let t2 = s2.readableTerm().split(separator: " ")
                if (t1[1] == t2[1]) {
                    return t1[0] < t2[0]
                }
                return t1[1] > t2[1]
            })
            self.termTable.reloadData();
        }, errorHandler: handleError)
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "api_token") // Clear token
        (self.navigationController as! NavigationController).setAnimationType(type: FadingAnimation.self, isRepeating: false)
        let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.setViewControllers([login!], animated: true)
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
        } else if (segue.identifier == "showSaved") {
            let dest = segue.destination as! SavedSchedulesVC
            dest.term = selectedRow
        }
    }
    
}
