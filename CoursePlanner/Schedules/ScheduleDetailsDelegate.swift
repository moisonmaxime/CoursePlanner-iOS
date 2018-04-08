//
//  ScheduleDetailsDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

extension SchedulesVC: ScheduleDetailsDelegate {
    func getSchedule() -> Schedule {
        return self.schedules[index]
    }
    func getTerm() -> String {
        return self.term
    }
    func isSaved() -> Bool {
        return type(of: self) == SavedSchedulesVC.self
    }
    func removeScheduleLocally() {
        if index >= schedules.count - 1 {
            index = index - 1
        }
        getInitialData()
    }
}
