//
//  List.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/26/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import Gloss

struct List {
    var id: String = UUID().uuidString
    var title: String = "New list"
    var tasks: [Item] = []
    var created: Date = Date()
    var isPrimary: Bool = true
}

extension List: Equatable {
    
    public static func ==(lhs: List, rhs: List) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.tasks.elementsEqual(rhs.tasks) &&
        lhs.created == rhs.created &&
        lhs.isPrimary == rhs.isPrimary
    }
}

extension List: Glossy {
    
    enum Key: String {
        case id = "_id"
        case type
        case title
        case tasks
        case created
        case isPrimary
    }
    
    init?(json: JSON) {
        guard let id: String = "_id" <~~ json else {
            return nil
        }
        self.id = id
        title = Key.title.rawValue <~~ json ?? ""
        tasks = Key.tasks.rawValue <~~ json ?? []
        created = Gloss.Decoder.decode(dateForKey: Key.created.rawValue, dateFormatter: DateFormatter())(json) ?? Date()
        isPrimary = Key.isPrimary.rawValue <~~ json ?? false
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            Key.id.rawValue ~~> id,
            Key.type.rawValue ~~> "list",//Database.View.list.rawValue,
            Key.title.rawValue ~~> title,
            Key.tasks.rawValue ~~> tasks,
            Key.created.rawValue ~~> DateFormatter().string(from: created),
            Key.isPrimary.rawValue ~~> isPrimary
        ])
    }
}
