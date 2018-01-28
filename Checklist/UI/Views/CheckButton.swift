//
//  CircleButton.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/29/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

/**
    Encapsualates the logic to toggle a check button on or off
    via a member variable.
 */
final class CheckButton: UIButton {
    
    // MARK: Properties
    
    var isChecked: Bool = false {
        didSet {
            configure()
        }
    }
    
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    /**
        Call any time the layout changes.
     */
    private func configure() {
        setImage(nil, for: .normal)
        layer.backgroundColor = isChecked ? Theme.current.colorTheme.secondaryLight.cgColor : UIColor.clear.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.width * 0.5
        layer.borderWidth = 0.5
        layer.borderColor = Theme.current.colorTheme.secondaryLight.cgColor
    }
}
