//
//  ListsRouter.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/17/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import UIKit

final class ListsViewControllerRouter: NSObject {
    
    weak var controller: UIViewController?
}

extension ListsViewControllerRouter: ListsViewControllerRouterInput {
    
    func openNewList() {
        let nextController = ListViewController()
        controller?.navigationController?.pushViewController(
            nextController, animated: true)
    }
    
    func openList(withId id: String) {
        let nextController = ListViewController(id: id)
        controller?.navigationController?.pushViewController(
            nextController, animated: true)
    }
    
    func presentErrorAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayButton)
        controller?.present(alert, animated: true, completion: nil)
    }
}
