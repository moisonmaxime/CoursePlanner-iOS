//
//  SavedSchedulesVC.swift
//  Lynx
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class SavedSchedulesVC: SchedulesVC {
    
    override func getInitialData() {
        self.navigationController?.didStartLoading(immediately: true)
        RestAPI.getSavedSchedule(term: term, completionHandler: { (response) in
            self.navigationController?.didFinishLoading()
            self.schedules = response
            self.schedules.sort(by: { (schedule1, schedule2) -> Bool in
                if (schedule1.numberOfDays == schedule2.numberOfDays) {
                    return schedule1.gaps < schedule2.gaps
                }
                return schedule1.numberOfDays < schedule2.numberOfDays
            })
            let noSchedule = self.schedules.first == nil || self.schedules[self.index].sections.count == 0
            self.currentScheduleLbl.isHidden = noSchedule
            self.detailssButton.isHidden = noSchedule
            self.nextButton.isHidden = noSchedule
            self.previousButton.isHidden = noSchedule
            self.weekDisplay.schedule = self.schedules.first
            self.weekDisplay.setNeedsDisplay()
        }, errorHandler: handleError)
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
