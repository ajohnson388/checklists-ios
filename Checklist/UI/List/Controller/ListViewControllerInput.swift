//
//  ListViewControllerInput.swift
//  Checklist
//
//  Created by Andrew Johnson on 1/27/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import Foundation

protocol ListViewControllerInput: class {
    func presentFetchListResponse(_ response: FetchList.Response)
    func presentAddTaskResponse(_ response: AddTask.Response)
    func presentDeleteTaskResponse(_ response: DeleteTask.Response)
    func presentMoveTaskResponse(_ response: MoveTask.Response)
    func presentCheckTaskResponse(_ response: CheckTask.Response)
    func presentUpdateListNameReponse(_ response: UpdateListName.Response)
    func presentUpdateTaskDescriptionResponse(_ response: UpdateTaskDescription.Response)
}
