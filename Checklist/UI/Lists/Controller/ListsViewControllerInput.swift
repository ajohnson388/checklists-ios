//
//  ListsViewControllerInput.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

protocol ListsViewControllerInput: class {
    func presentFetchResult(_ result: FetchLists.Response)
    func presentDeleteResult(_ result: DeleteLists.Response)
}
