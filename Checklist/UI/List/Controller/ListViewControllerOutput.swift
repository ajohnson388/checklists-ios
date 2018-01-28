//
//  ListViewControllerOutput.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

protocol ListViewControllerOutput: class {
    var viewModel: List? { get }
    func fetchList(withRequest request: FetchList.Request)
    func addTask(withRequest request: AddTask.Request)
    func moveTask(withRequest request: MoveTask.Request)
    func deleteTask(withRequest request: DeleteTask.Request)
    func checkTask(withRequest request: CheckTask.Request)
    func updateTaskDescription(withRequest request: UpdateTaskDescription.Request)
    func updateListName(witRequest request: UpdateListName.Request)
}
