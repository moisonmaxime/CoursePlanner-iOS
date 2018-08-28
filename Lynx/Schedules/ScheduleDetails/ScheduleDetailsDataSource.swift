//
//  ScheduleDetailsDataSource.swift
//  Lynx
//
//  Created by Maxime Moison on 4/7/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension ScheduleDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailDelegate.getSchedule().courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as? CourseCell
        cell?.selectionStyle = .none
        cell?.setup(course: detailDelegate.getSchedule().courses[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
