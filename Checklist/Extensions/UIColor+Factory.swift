//
//  UIColor+Factory.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/27/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static var clouds: UIColor {
        return UIColor(r: 236, g: 240, b: 241)
    }
    
    static var materialDarkBlack: UIColor {
        return UIColor(r: 43, g: 43, b: 43)
    }
    
    static var materialBlack: UIColor {
        return UIColor(r: 49, g: 51, b: 52)
    }
    
    static var materialLightBlack: UIColor {
        return UIColor(r: 60, g: 63, b: 65)
    }
    
    static var materialGray: UIColor {
        return UIColor(r: 125, g: 125, b: 125)
    }
}
