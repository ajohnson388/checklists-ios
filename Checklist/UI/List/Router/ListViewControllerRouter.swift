//
//  ListViewRouter.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/17/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

final class ListViewControllerRouter: NSObject {
    
    weak var viewController: UIViewController!
    
    override init() {
        super.init()
    }
}

extension ListViewControllerRouter: ListViewControllerRouterInput {
    
    func presentErrorAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayButton)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
