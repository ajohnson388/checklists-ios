//
//  Item.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/26/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import Gloss

struct Item {
    var text: String = ""
    var isChecked: Bool = false
}

extension Item: Equatable {
    
    public static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.text == rhs.text
            && lhs.isChecked == rhs.isChecked
    }
}


// MARK: Glossy

extension Item: Glossy {
    
    init?(json: JSON) {
        text = "text" <~~ json ?? ""
        isChecked = "isChecked" <~~ json ?? false
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "text" ~~> text,
            "isChecked" ~~> isChecked
        ])
    }
}
