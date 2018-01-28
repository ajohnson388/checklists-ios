//
//  CheckTask.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct CheckTask {
    
    struct Request {
        let index: Int
        let isChecked: Bool
    }
    
    enum Response {
        case success
        case error(error: Error)
    }
}
