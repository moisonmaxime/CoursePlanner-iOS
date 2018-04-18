//
//  HomeTableDatasource.swift
//  CoursePlanner
//
//  Created by Maxime Moison on 3/21/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation
import UIKit

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermCell") as! TermCell
        cell.termLabel.text = terms[indexPath.row].readableTerm()
        cell.selectionStyle = .none
        cell.updateView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
