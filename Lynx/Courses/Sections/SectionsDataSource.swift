//
//  SectionsTableDataSource.swift
//  Lynx
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as? CourseCell
        cell?.selectionStyle = .none
        let section = sections[indexPath.row]
        let isAvailable = !sectionsDelegate.getBadCRNs().contains(section.crn)
        cell?.load(with: (section, isAvailable))
        return cell ?? UITableViewCell()
    }
}
