//
//  SwapTasks.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct MoveTask {
    
    struct Request {
        let fromIndex: Int
        let toIndex: Int
        let shouldSave: Bool = false
    }
    
    enum Response {
        case success
        case error(error: Error)
    }
}
