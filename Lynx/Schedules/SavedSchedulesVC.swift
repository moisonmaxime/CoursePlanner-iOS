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
        RestAPI.getSavedSchedule(term: term, completionHandler: { [weak self] schedules in
            self?.navigationController?.didFinishLoading()
            self?.loadSchedules(schedules)
        }, errorHandler: { [weak self] error in
            self?.handleError(error: error)
            self?.schedules = []
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
