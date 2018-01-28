//
//  Theme.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/27/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeType {
    var colorTheme: ColorTheme { get }
    var systemTheme: SystemTheme { get }
}

struct Theme {
    static let current: ThemeType = DarkTheme()
}

protocol SystemTheme {
    var keyboardAppearance: UIKeyboardAppearance { get }
}

protocol ColorTheme {
    var primaryDark: UIColor { get }
    var primaryLight: UIColor { get }
    var secondaryDark: UIColor { get }
    var secondaryLight: UIColor { get }
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
}
