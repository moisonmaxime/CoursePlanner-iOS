//
//  CellProtocols.swift
//  Lynx
//
//  Created by Maxime Moison on 10/9/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

protocol CellLoadable where Self: UITableViewCell {
    associatedtype PayloadType
    func load(with payload: PayloadType)
}

protocol CellActionable where Self: UITableViewCell {
    var didTap: (() -> Void)? { get }
}

protocol CellSizeable where Self: UITableViewCell {
    var cellHeight: CGFloat { get }
}
