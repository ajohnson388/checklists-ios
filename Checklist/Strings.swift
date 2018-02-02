//
//  Strings.swift
//  Checklist
//
//  Created by Andrew Johnson on 2/1/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

enum Strings: String {
    case listsTitle = "lists_title"
    case newListTitle = "list_new_title"
    case addNewTaskPlaceholder = "list_new_task_placeholder"
    case noListsMessage = "lists_empty_message"
    case deleteTaskButtonTitle = "list_task_delete"
}


extension Strings {
    
    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
