//
//  ListViewConfigurator.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/17/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

final class ListViewConfigurator: NSObject {
    
    private override init() {
        super.init()
    }
}

extension ListViewConfigurator: ListViewConfiguratorType {
    
    static func configure(viewController: ListViewController) {
        // Link the router
        let router = ListViewControllerRouter()
        router.viewController = viewController
        viewController.router = router
        
        // Link the interactor / presenter
        let interactor = ListViewInteractor()
        interactor.presenter = viewController
        viewController.interactor = interactor
    }
}
