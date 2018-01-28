//
//  FetchList.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

struct FetchList {
    
    struct Request {
        var id: String? = nil
    }
    
    enum Response {
        case succcess
        case error(error: Error)
    }
}
