//
//  EmptyTableView.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/9/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class EmptyTableView: UIView {
    
    // MARK: Properties
    
    let textLabel = UILabel(frame: CGRect.null)
    
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.null)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    // MARK: Setup
    
    fileprivate func setup() {
        addViews()
        configureViews()
        applyAutolayout()
    }
    
    fileprivate func addViews() {
        if !subviews.contains(textLabel) {
            addSubview(textLabel)
        }
    }
    
    fileprivate func configureViews() {
        textLabel.numberOfLines = 0
        textLabel.textColor = Theme.current.colorTheme.secondaryText
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 16)
        textLabel.text = "There are no lists to display. \nTry adding one by tapping the '+' button."
        textLabel.textAlignment = .center
    }
    
    fileprivate func applyAutolayout() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
