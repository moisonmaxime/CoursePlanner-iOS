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
        cell?.setup(section: sections[indexPath.row])
        cell?.updateAvailability(sectionsDelegate.getBadCRNs())
        cell?.updateView()
        return cell ?? UITableViewCell()
    }
}
