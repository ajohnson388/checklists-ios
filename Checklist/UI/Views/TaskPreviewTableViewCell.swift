//
//  TaskPreviewTableViewCell.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/27/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

/**
    A scalable version of the check list cells intended for read-only.
 */
final class TaskPreviewTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    /**
        Determines how much to shrink the view for display.
     */
    var scale: CGFloat = 1 {
        didSet {
            setup()
        }
    }
    
    let checkButton: CheckButton = CheckButton(frame: CGRect.null)
    let taskLabel = UILabel(frame: CGRect.null)
    
    
    // MARK: Initializers
    
    init(reuseId: String?) {
        super.init(style: .default, reuseIdentifier: reuseId)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup
    
    fileprivate func setup() {
        addViews()
        configureViews()
        applyAutoLayoutConstraints()
    }
    
    fileprivate func addViews() {
        if !subviews.contains(checkButton) {
            addSubview(checkButton)
        }
        if !subviews.contains(taskLabel) {
            addSubview(taskLabel)
        }
    }
    
    fileprivate func configureViews() {
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.adjustsFontSizeToFitWidth = true
        taskLabel.font = UIFont(name: "Helvetica", size: 12 * scale)
    }
    
    fileprivate func applyAutoLayoutConstraints() {
        // Define constraints
        let views: [String: UIView] = [
            "checkButton": checkButton,
            "textField": taskLabel
        ]
        let metrics = [
            "spacing": 8 * scale,
            "spacingButton": 16 * scale,
            "buttonSize": 28 * scale
        ]
        let formatStrings = [
            "V:|-(spacing)-[checkButton(buttonSize)]-(spacing)-|",
            "V:|-(spacing)-[textField(buttonSize)]-(spacing)-|",
            "H:|-(spacing)-[checkButton(buttonSize)]-(spacingButton)-[textField]-(spacing)-|"
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
