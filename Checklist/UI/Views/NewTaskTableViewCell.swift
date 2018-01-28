//
//  NewTaskTableViewCell.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/9/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

/**
    Used by the check list view to for adding new tasks. This cell
    does not include a check button.
 */
final class NewTaskTableViewCell: UITableViewCell {

    // MARK: Properties

    let textField = UITextField(frame: CGRect.null)
    
    
    // MARK: Initializers
    
    init(reuseId: String?) {
        super.init(style: .default, reuseIdentifier: reuseId)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: Setup
    
    fileprivate func setup() {
        addViews()
        configureViews()
        applyAutoLayoutConstraints()
    }
    
    fileprivate func addViews() {
        addSubview(textField)
    }
    
    fileprivate func configureViews() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add task..."
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.enablesReturnKeyAutomatically = false
        textField.keyboardAppearance = Theme.current.systemTheme.keyboardAppearance
    }
    
    fileprivate func applyAutoLayoutConstraints() {
        // Define constraints
        let views: [String: UIView] = [
            "textField": textField
        ]
        let formatStrings = [
            "V:|-16-[textField]-16-|",
            "H:|-[textField]-|"
        ]
        
        // Apply constraints
        for formatString in formatStrings {
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: formatString,
                options: [],
                metrics: nil,
                views: views)
            NSLayoutConstraint.activate(constraints)
        }
    }
}
