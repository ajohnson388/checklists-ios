//
//  DarkTheme.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/31/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

struct DarkColorTheme: ColorTheme {
    let primaryDark = UIColor.black
    let primaryLight = UIColor(r: 20, g: 20, b: 20)
    let secondaryDark = UIColor(r: 99, g: 97, b: 84)
    let secondaryLight = UIColor(r: 127, g: 127, b: 127)
    let primaryText = UIColor.clouds
    let secondaryText = UIColor.gray
}

struct DarkTheme: ThemeType {
    let colorTheme: ColorTheme = DarkColorTheme()
    let systemTheme: SystemTheme = DarkSystemTheme()
}

struct DarkSystemTheme: SystemTheme {
    let keyboardAppearance: UIKeyboardAppearance = .dark
}
