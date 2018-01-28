//
//  Database.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/26/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

struct Database {
    
    enum View: String {
        case list
    }
    
    private static var database: CBLDatabase {
        return try! CBLManager.sharedInstance().databaseNamed("list_db")
    }
    
    // MARK: Getters
    
    static func getList(id: String) -> List? {
        guard let json = database.document(withID: id)?.properties else {
            return nil
        }
        return List(json: json)
    }
    
    static func getPrimaryList() -> List? {
        let query = database.createAllDocumentsQuery()
        query.allDocsMode = .allDocs
        query.prefetch = true
        query.descending = true
        
        let enumerator = try! query.run()
        while let row = enumerator.nextRow() {
            guard let json = row.documentProperties else {
                continue
            }
            guard json["type"] as? String == View.list.rawValue else {
                continue
            }
            guard let list = List(json: json), list.isPrimary else {
                continue
            }
            return list
        }
        return nil
    }
    
    static func getLists() -> [List] {
        
        let query = database.createAllDocumentsQuery()
        query.allDocsMode = .allDocs
        query.prefetch = true
        query.descending = true
        
        let enumerator = try! query.run()
        
        var lists: [List] = []
        while let row = enumerator.nextRow() {
            guard let json = row.documentProperties else {
                continue
            }
            guard json["type"] as? String == View.list.rawValue else {
                continue
            }
            guard let list = List(json: json) else {
                continue
            }
            lists.append(list)
        }
        return lists
    }
    
    
    // MARK: Setters
    
    static func save(list: List) throws {
        // Get and cleanup json
        guard var json = list.toJSON() else {
            return
        }
        json.removeValue(forKey: "_id")
        let doc = database.document(withID: list.id)
        json["_rev"] = doc?.currentRevisionID
        
        do {
            _ = try doc?.putProperties(json)
        } catch {
            print("Failed to save list")
        }
    }
    
    static func register(observer: Any, forListWithId id: String, onChange: @escaping (List?) -> ()) {
        NotificationCenter.default.addObserver(forName:
            NSNotification.Name.cblDatabaseChange, object: observer, queue: nil) { notification in
            guard let changes = notification.userInfo?["changes"] as? [CBLDatabaseChange] else {
                return
            }
            for change in changes where change.documentID == id {
                let list = getList(id: id)
                onChange(list)
            }
        }
    }
    
    static func unregister(observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }

    
    
    // MARK: Destructors
    
    static func delete(id: String) {
        try? database.document(withID: id)?.delete()
    }
}
