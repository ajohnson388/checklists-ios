//
//  UITableView+Utils.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/28/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func scroll(toBottomOfSection section: Int, animated: Bool) {
        let numRows = numberOfRows(inSection: section)
        guard numRows > 0 else {
            return
        }
        
        let bottomIndexPath = IndexPath(row: numRows - 1, section: section)
        scrollToRow(at: bottomIndexPath, at: .bottom, animated: animated)
    }
    
    func indexPath(forElement element: UICoordinateSpace) -> IndexPath? {
        let position = element.convert(CGPoint.zero, to: self)
        return indexPathForRow(at: position)
    }
}
