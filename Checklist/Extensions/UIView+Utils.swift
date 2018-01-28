//
//  UIView+Utils.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/16/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
        Creates an image view copy of a view that retains the original bounds.
     
        - returns:
            The image view copy or nil if the context could not be retrieved.
     */
    func makeSnapshot() -> UIView? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        // Make an image from the input view.
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to get the current context. Cannot create snapshot.")
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Create an image view.
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
}
