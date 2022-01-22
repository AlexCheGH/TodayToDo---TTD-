//
//  TableView + Utilities.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/22/22.
//

import Foundation
import UIKit

extension UITableView {

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
