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
            currentScheduleLbl.isHidden = schedules.first == nil || schedules[index].sections.count == 0
            weekDisplay.schedule = schedules[index]
            weekDisplay.setNeedsDisplay()
        }
    }
    
    @IBOutlet weak var weekDisplay: WeekCalendar!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentScheduleLbl: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var detailssButton: UIButton!
    
    var schedules:[Schedule] = [] {
        didSet {
            currentScheduleLbl.text! = "\(index + 1)/\(schedules.count)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = term?.readableTerm()
        checkButtonStates()
        getInitialData()
    }
    
    func getInitialData() {
        (self.navigationController as! NavigationController).didStartLoading(immediately: true)
        RestAPI.getSchedules(term: term, courses: courses, completion: { (response, error) in
            DispatchQueue.main.async {
                (self.navigationController as! NavigationController).didFinishLoading()
                if (error != nil) {
                    self.handleError(error: error!)
                }
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
                if (self.schedules.count == 0) {
                    print("No schedule!")
                }
                self.currentScheduleLbl.isHidden = self.schedules.first == nil || self.schedules[self.index].sections.count == 0
                self.detailssButton.isHidden = self.schedules.first == nil || self.schedules[self.index].sections.count == 0
                self.weekDisplay.schedule = self.schedules.first
                self.checkButtonStates()
                self.weekDisplay.setNeedsDisplay()
            }
        })
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showScheduleDetails") {
            let vc = segue.destination as! ScheduleDetailsVC
            vc.detailDelegate = self
        }
    }
    
    
}
