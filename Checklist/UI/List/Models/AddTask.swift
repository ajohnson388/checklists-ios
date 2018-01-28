//
//  AddTask.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct AddTask {
    
    struct Request {
        let description: String
    }
    
    enum Response {
        case success
        case error(error: Error)
    }
}
