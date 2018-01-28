//
//  ListViewControllerInteractor.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/16/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

final class ListViewInteractor: NSObject {
    
    weak var presenter: ListViewControllerInput?
    var viewModel: List?
    
    override init() {
        super.init()
    }
}


extension ListViewInteractor: ListViewControllerOutput {
    
    func fetchList(withRequest request: FetchList.Request) {
        viewModel = request.id == nil ? List() : Database.getList(id: request.id!)
        presenter?.presentFetchListResponse(FetchList.Response.succcess)
    }
    
    func addTask(withRequest request: AddTask.Request) {
        let newTask = Item(text: request.description, isChecked: false)
        viewModel?.tasks.append(newTask)
        
        guard let list = viewModel else {
            presenter?.presentAddTaskResponse(AddTask.Response.success)
            return
        }
        
        do {
            try Database.save(list: list)
            presenter?.presentAddTaskResponse(AddTask.Response.success)
        } catch (let error) {
            let response = AddTask.Response.error(error: error)
            presenter?.presentAddTaskResponse(response)
        }
    }
    
    
    func moveTask(withRequest request: MoveTask.Request) {
        viewModel?.tasks.swapAt(request.fromIndex, request.toIndex)
        
        guard let list = viewModel, request.shouldSave else {
            presenter?.presentMoveTaskResponse(MoveTask.Response.success)
            return
        }
        
        do {
            try Database.save(list: list)
            presenter?.presentMoveTaskResponse(MoveTask.Response.success)
        } catch(let error) {
            let response = MoveTask.Response.error(error: error)
            presenter?.presentMoveTaskResponse(response)
        }
    }
    
    func deleteTask(withRequest request: DeleteTask.Request) {
        viewModel?.tasks.remove(at: request.index)
        
        guard let list = viewModel else {
            presenter?.presentDeleteTaskResponse(DeleteTask.Response.success)
            return
        }
        
        do {
            try Database.save(list: list)
            presenter?.presentDeleteTaskResponse(DeleteTask.Response.success)
        } catch(let error) {
            let response = DeleteTask.Response.error(error: error)
            presenter?.presentDeleteTaskResponse(response)
        }
    }
    
    func checkTask(withRequest request: CheckTask.Request) {
        viewModel?.tasks[request.index].isChecked = request.isChecked
        
        guard let list = viewModel else {
            presenter?.presentCheckTaskResponse(CheckTask.Response.success)
            return
        }
        
        do {
            try Database.save(list: list)
        } catch(let error) {
            let response = CheckTask.Response.error(error: error)
            presenter?.presentCheckTaskResponse(response)
        }
    }
    
    func updateTaskDescription(withRequest request: UpdateTaskDescription.Request) {
        viewModel?.tasks[request.index].text = request.description
        
        guard let list = viewModel else {
            presenter?.presentUpdateTaskDescriptionResponse(UpdateTaskDescription.Response.success)
            return
        }
        
        do {
            try Database.save(list: list)
        } catch(let error) {
            let response = UpdateTaskDescription.Response.error(error: error)
            presenter?.presentUpdateTaskDescriptionResponse(response)
        }
    }
    
    func updateListName(witRequest request: UpdateListName.Request) {
        viewModel?.title = request.name
        
        guard let list = viewModel else {
            presenter?.presentUpdateListNameReponse(UpdateListName.Response.success)
            return
        }
        
        do {
            try Database.save(list: list)
        } catch(let error) {
            let response = UpdateListName.Response.error(error: error)
            presenter?.presentUpdateListNameReponse(response)
        }
    }
}
