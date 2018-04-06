//
//  SectionsTableDataSource.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 4/3/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

extension SectionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as! CourseCell
        cell.selectionStyle = .none
        cell.setup(course: sections[indexPath.row])
        cell.setSelected(courseVC.badCRNs.contains(sections[indexPath.row]["crn"] as! String), animated: false)
        cell.updateAvailability(courseVC.badCRNs)
        cell.updateView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
