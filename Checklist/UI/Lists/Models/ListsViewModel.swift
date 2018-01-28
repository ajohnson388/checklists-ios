//
//  ListsModel.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/18/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

// MARK: View Model

struct ListsViewModel {
    
    struct List {
        var id: String
        var title: String
        var subtitle: String
    }
    
    let lists: [ListsViewModel.List]
    
    init(lists: [Checklist.List]) {
        self.lists = lists.map(ListsViewModel.makeListModel)
    }
    
    private static func makeListModel(from list: Checklist.List) ->
        ListsViewModel.List {
            
        let tasks = list.tasks
        let amountChecked = tasks.reduce(into: 0) { result, item in
            if item.isChecked { result += 1 }
        }
            
        let subtitle = "\(amountChecked)/\(tasks.count)"
        return ListsViewModel.List(id: list.id,
                                   title: list.title,
                                   subtitle: subtitle)
    }
}
