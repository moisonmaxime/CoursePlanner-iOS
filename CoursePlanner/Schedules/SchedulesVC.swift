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
    var badCRNs:[String]!
    
    var index:Int = 0 {
        didSet {
            currentScheduleLbl.text! = "\(index + 1)/\(schedules.count)"
            checkButtonStates()
            weekDisplay.schedule = schedules[index]
            weekDisplay.setNeedsDisplay()
        }
    }
    
    @IBOutlet weak var weekDisplay: WeekCalendar!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentScheduleLbl: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    
    var schedules:[Schedule] = [] {
        didSet {
            currentScheduleLbl.text! = "\(index + 1)/\(schedules.count)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = term?.readableTerm()
        checkButtonStates()
        
        RestAPI.getSchedules(term: term, courses: courses, completion: { (response, error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.handleError(error: error!)
                }
            }
            DispatchQueue.main.async {
                self.schedules = response!.filter({ (schedule) -> Bool in
                    for section in schedule.sections {
                        for course in section.courses {
                            if (self.badCRNs.contains(course.crn)) {
                                return false
                            }
                        }
                    }
                    return true
                })
                // print(self.schedules)
                if (self.schedules.count == 0) {
                    print("No schedule!")
                }
                self.weekDisplay.schedule = self.schedules.first
                self.checkButtonStates()
                self.weekDisplay.setNeedsDisplay()
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    func checkButtonStates() {
        previousButton.isEnabled = (index != 0)
        nextButton.isEnabled = (index < schedules.count - 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func previous(_ sender: Any) {
        index = index - 1
    }
    
    @IBAction func next(_ sender: Any) {
        index = index + 1
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
