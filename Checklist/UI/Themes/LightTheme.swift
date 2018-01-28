//
//  LightTheme.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/31/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

struct LightColorTheme: ColorTheme {
    let primaryDark = UIColor.clouds
    let primaryLight = UIColor.white
    let secondaryDark = UIColor.darkGray
    let secondaryLight = UIColor.black
    let primaryText = UIColor.darkText
    let secondaryText = UIColor.lightGray
}

struct LightTheme: ThemeType {
    let colorTheme: ColorTheme = LightColorTheme()
    let systemTheme: SystemTheme = LightSystemTheme()
}

struct LightSystemTheme: SystemTheme {
    let keyboardAppearance: UIKeyboardAppearance = .light
}
