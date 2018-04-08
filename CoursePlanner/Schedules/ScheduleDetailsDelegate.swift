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
}
