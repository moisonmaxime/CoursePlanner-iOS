//
//  SchedulesVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/25/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class SchedulesVC: UIViewController {

    var term:String!
    var courses:[String]!
    
    @IBOutlet weak var weekDisplay: WeekCalendar!
    var schedules:[Schedule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestAPI.getSchedules(term: term, courses: courses, completion: { (response, error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.handleError(error: error!)
                }
            }
            self.schedules = response!
            // print(self.schedules)
            self.weekDisplay.schedule = self.schedules.first
            DispatchQueue.main.async {
                self.weekDisplay.setNeedsDisplay()
            }
        })
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
