//
//  DeleteTask.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct DeleteTask {
    
    struct Request {
        let index: Int
    }
    
    enum Response {
        case success
        case error(error: Error)
    }
}
