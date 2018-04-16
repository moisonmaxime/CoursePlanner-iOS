//
//  SavedSchedulesVC.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class SavedSchedulesVC: SchedulesVC {
    
    override func getInitialData() {
        (self.navigationController as! NavigationController).didStartLoading(immediately: true)
        RestAPI.getSavedSchedule(completion: { (response, error) in
            DispatchQueue.main.async {
                if let nav = (self.navigationController as? NavigationController) {
                    nav.didFinishLoading()
                    if (error != nil) {
                        self.handleError(error: error!)
                    } else {
                        self.schedules = response!
                    }
                    self.schedules.sort(by: { (s1, s2) -> Bool in
                        if (s1.days! == s2.days!) {
                            return s1.gaps! < s2.gaps!
                        }
                        return s1.days! < s2.days!
                    })
                    self.currentScheduleLbl.isHidden = self.schedules.first == nil || self.schedules[self.index].sections.count == 0
                    self.detailssButton.isHidden = self.schedules.first == nil || self.schedules[self.index].sections.count == 0
                    self.weekDisplay.schedule = self.schedules.first
                    self.checkButtonStates()
                    self.weekDisplay.setNeedsDisplay()
                }
            }
        })
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
