//
//  HomeTableDelegate.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = terms[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as! TermCell
        cell.setSelected(true, animated: true)
        cell.updateView()
    }
}
