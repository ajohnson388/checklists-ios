//
//  ListsViewControllerOutput.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

protocol ListsViewControllerOutput: class {
    var viewModel: ListsViewModel? { get }
    func fetchLists(withRequest request: FetchLists.Request)
    func deleteLists(withRequest request: DeleteLists.Request)
}

extension ListsViewControllerOutput {
    
    func fetchLists(withRequest request: FetchLists.Request
        = FetchLists.Request()) {
        self.fetchLists(withRequest: request)
    }
}
