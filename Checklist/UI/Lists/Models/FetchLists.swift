//
//  FetchLists.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct FetchLists {
    
    struct Request {}
    
    enum Response {
        case Success
        case Error(error: Error)
    }
}
