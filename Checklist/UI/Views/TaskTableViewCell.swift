//
//  TaskTableViewCell.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/28/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    // MARK: Fields
    
    let checkButton = CheckButton(frame: CGRect.null)
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
    
    func setup() {
        addViews()
        configureViews()
        applyAutoLayoutConstraints()
    }
    
    fileprivate func addViews() {
        addSubview(checkButton)
        addSubview(textField)
    }
    
    fileprivate func configureViews() {
        checkButton.translatesAutoresizingMaskIntoConstraints = false
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
            "checkButton": checkButton,
            "textField": textField
        ]
        let metrics = [
            "buttonSize": 44
        ]
        let formatStrings = [
            "V:|-(>=8)-[checkButton(buttonSize)]-|",
            "V:|-[textField]-|",
            "H:|-[checkButton(buttonSize)]-16-[textField(buttonSize)]-36-|"
        ]
        
        // Apply constraints
        for formatString in formatStrings {
            let constraints = NSLayoutConstraint.constraints(
                withVisualFormat: formatString,
                options: [],
                metrics: metrics,
                views: views)
            NSLayoutConstraint.activate(constraints)
        }
        
        // Apply aspect ratio constraint
        let aspectRatio = NSLayoutConstraint(
            item: checkButton,
            attribute: .height,
            relatedBy: .equal,
            toItem: checkButton,
            attribute: .width,
            multiplier: 1,
            constant: 0)
        NSLayoutConstraint.activate([aspectRatio])
    }
}
