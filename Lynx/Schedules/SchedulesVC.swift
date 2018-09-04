//
//  SchedulesVC.swift
//  Lynx
//
//  Created by Maxime Moison on 3/25/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class SchedulesVC: UIViewController {

    var term: String!
    var courses: [String]!
    var badCRNs: [String]!

    var index: Int = 0 {
        didSet {
            index = index % schedules.count
            index = index < 0 ? index + schedules.count : index
            currentScheduleLbl.text! = "\(index + 1)/\(schedules.count)"
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

    var schedules: [Schedule] = [] {
        didSet {
            currentScheduleLbl.text! = "\(index + 1)/\(schedules.count)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = term?.readableTerm()
        getInitialData()
    }

    func getInitialData() {
        self.navigationController?.didStartLoading(immediately: true)
        RestAPI.getSchedules(term: term, courses: courses, completionHandler: { schedules in
            self.navigationController?.didFinishLoading()
            self.schedules = schedules
            let noSchedule = self.schedules.first == nil || self.schedules[self.index].sections.count == 0
            self.currentScheduleLbl.isHidden = noSchedule
            self.detailssButton.isHidden = noSchedule
            self.nextButton.isHidden = noSchedule
            self.previousButton.isHidden = noSchedule
            self.weekDisplay.schedule = self.schedules.first
            self.weekDisplay.setNeedsDisplay()
        }, errorHandler: { error in
            self.handleError(error: error)
            self.schedules = []
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func previous(_ sender: Any) {
        index -= 1
    }

    @IBAction func next(_ sender: Any) {
        index += 1
    }

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if index > 0 {
            previous(sender)
        }
    }

    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if index < schedules.count-1 {
            next(sender)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showScheduleDetails" {
            if let destination = segue.destination as? ScheduleDetailsVC {
                destination.detailDelegate = self
            }
        }
    }

}
