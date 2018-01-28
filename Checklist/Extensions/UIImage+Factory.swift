//
//  UIImage+Factory.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/9/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static var checked: UIImage {
        return UIImage(named: "checked")!
    }
    
    static var unchecked: UIImage {
        return UIImage(named: "unchecked")!
    }
}
