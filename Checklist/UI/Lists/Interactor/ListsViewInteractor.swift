//
//  ListsViewModel.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/17/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

final class ListsViewInteractor: NSObject {
    
    weak var controllerInput: ListsViewControllerInput!
    var viewModel: ListsViewModel?
    
    override init() {
        super.init()
    }
}

extension ListsViewInteractor: ListsViewControllerOutput {
    
    func fetchLists(withRequest request: FetchLists.Request) {
        // Do async work and publish to UI
        let lists = Database.getLists()
        viewModel = ListsViewModel(lists: lists)
        controllerInput.presentFetchResult(.Success)
    }
    
    func deleteLists(withRequest request: DeleteLists.Request) {
        request.identifiers.forEach(Database.delete)
        
        let lists = Database.getLists()
        viewModel = ListsViewModel(lists: lists)
        controllerInput.presentDeleteResult(.success)
    }
}
