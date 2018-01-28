//
//  ListsViewConfigurator.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/17/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

final class ListsViewConfigurator: NSObject {
    
    private override init() {
        super.init()
    }
}

extension ListsViewConfigurator: ListsViewConfiguratorType {
    
    static func configure(viewController: ListsViewController) {
        // Link the router
        let router = ListsViewControllerRouter()
        router.controller = viewController
        viewController.router = router
        
        // Link the interactor / presenter
        let interactor = ListsViewInteractor()
        interactor.controllerInput = viewController
        viewController.interactor = interactor
    }
}
