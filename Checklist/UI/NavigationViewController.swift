//
//  NavigationViewController.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/29/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class NavigationViewController: UINavigationController {
    
    // MARK: Object Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationViewController.configure(navigationController: self)
    }
}


// MARK: Configuration

fileprivate extension NavigationViewController {
    
    static func configure(navigationController: UINavigationController) {
        NavigationViewController.configureTheme(for: navigationController.navigationBar)
        NavigationViewController.configureTheme(for: navigationController.toolbar)
    }
    
    static func configureTheme(for toolBar: UIToolbar) {
        toolBar.barTintColor = Theme.current.colorTheme.primaryLight
        toolBar.isOpaque = true
        toolBar.isTranslucent = false
        toolBar.tintColor = Theme.current.colorTheme.secondaryLight
        toolBar.barStyle = .blackOpaque
    }
    
    static func configureTheme(for navigationBar: UINavigationBar) {
        navigationBar.barTintColor = Theme.current.colorTheme.primaryLight
        navigationBar.isOpaque = true
        navigationBar.isTranslucent = false
        navigationBar.tintColor = Theme.current.colorTheme.secondaryLight
        navigationBar.barStyle = .blackOpaque
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: Theme.current.colorTheme.secondaryLight
        ]
    }
}


// MARK: Navigation Delegate

extension NavigationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        NavigationViewController.configure(navigationController: navigationController)
    }
}
