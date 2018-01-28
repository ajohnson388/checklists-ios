//
//  UIGestureRecognizer+Utils.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/16/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    
    func abort() {
        isEnabled = false
        isEnabled = true
    }
}
