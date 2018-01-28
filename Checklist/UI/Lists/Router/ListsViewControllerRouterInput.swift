//
//  ListsViewControllerRouterInput.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

protocol ListsViewControllerRouterInput: class {
    func openNewList()
    func openList(withId id: String)
    func presentErrorAlert(withMessage message: String)
}
