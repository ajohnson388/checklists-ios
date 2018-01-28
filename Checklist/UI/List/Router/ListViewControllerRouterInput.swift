//
//  ListViewControllerRouterInput.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

protocol ListViewControllerRouterInput: class {
    func presentErrorAlert(withMessage message: String)
}
