//
//  ListsViewController.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/26/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class ListViewController: UITableViewController {
    
    private enum FieldType: Int {
        case title = 1, task
    }
    
    // MARK: Properties
    
    var interactor: ListViewControllerOutput!
    var router: ListViewControllerRouterInput!
    
    var listTitleTextField: UITextField?
    var sourceIndexPath: IndexPath?
    var snapshot: UIView?
    
    
    // MARK: Initializers
    
    init(id: String) {
        super.init(style: .grouped)
        ListViewConfigurator.configure(viewController: self)
        
        let request = FetchList.Request(id: id)
        interactor?.fetchList(withRequest: request)
    }
    
    init() {
        super.init(style: .grouped)
        ListViewConfigurator.configure(viewController: self)
        
        let request = FetchList.Request()
        interactor?.fetchList(withRequest: request)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Setup
    
    func setupNavBar() {
        let textFieldWidth = navigationController?.navigationBar.frame.size.width ?? 0
        listTitleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth - 128, height: 21))
        guard let textField = listTitleTextField else { return }
        textField.textAlignment = NSTextAlignment.center
        textField.text = interactor.viewModel?.title ?? "New Task"
        textField.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        textField.delegate = self
        textField.tag = FieldType.title.rawValue
        textField.returnKeyType = .done
        textField.textColor = Theme.current.colorTheme.secondaryLight
        textField.keyboardType = .alphabet
        textField.keyboardAppearance = Theme.current.systemTheme.keyboardAppearance
        navigationItem.titleView = textField

    }
    
    func setupTableView() {
        tableView.backgroundColor = Theme.current.colorTheme.primaryDark
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 0)
        tableView.separatorColor = Theme.current.colorTheme.secondaryLight
    }

    
    // MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupLongPress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        focusKeyboardIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    
    // MARK: Selectors
    
    @objc func didTapCheckButton(_ sender: UIButton) {
        if let indexPath = tableView.indexPath(forElement: sender) {
            toggleChecked(at: indexPath)
        }
    }
}


// MARK: Keyboard Utils

extension ListViewController {
    
    func focusKeyboardIfNeeded() {
        guard interactor.viewModel?.tasks.count ?? 0 == 0 else {
            return
        }
        focusKeyboardOnNewTask()
    }
    
    func focusKeyboardOnNewTask() {
        let indexPath = IndexPath(row: interactor.viewModel?.tasks.count ?? 0, section: 0)
        let onFinish: () -> () = { self.focusKeyboard(at: indexPath) }
        CATransaction.begin()
        CATransaction.setCompletionBlock(onFinish)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        CATransaction.commit()
    }
    
    func focusKeyboard(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let taskCell = cell as? TaskTableViewCell {
            taskCell.textField.becomeFirstResponder()
        } else if let newTaskCell = cell as? NewTaskTableViewCell {
            newTaskCell.textField.becomeFirstResponder()
        } else {
            print("Failed to focus on the task cell")
        }
    }
    
    func focusKeyboardOnNextCell(at indexPath: IndexPath) {
        let nextPath  = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        let cell = tableView.cellForRow(at: nextPath) as? TaskTableViewCell
        cell?.textField.becomeFirstResponder()
    }
}


// MARK: Gesture Recognizers

extension ListViewController {
    
    func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        longPress.minimumPressDuration = 0.4
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: tableView)
        switch sender.state {
        case .began:
            didBeginMovingTask(from: location)
        case .changed:
            didMoveTask(to: location)
        default:
            didFinishMovingTask(to: location)
        }
    }
    
    func didBeginMovingTask(from location: CGPoint) {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                return
        }
        
        // Keep track of the cell being moved
        sourceIndexPath = indexPath
        snapshot = cell.makeSnapshot()
        guard let snapshot = snapshot else {
            return
        }
        
        // Configure the snapshot
        let center = cell.center
        snapshot.center = center
        snapshot.alpha = 0
        tableView.addSubview(snapshot)
        
        // Animate the cell being grabbed
        UIView.animate(withDuration: 0.3, animations: {
            snapshot.center = CGPoint(x: cell.center.x, y: location.y)
            snapshot.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
            snapshot.alpha = 0.98
            cell.alpha = 0.0
        }, completion: { completed in
            cell.isHidden = true
        })
    }
    
    func didMoveTask(to location: CGPoint) {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let sourcePath = sourceIndexPath,
              let snapshot = snapshot else {
            return
        }
        var center = snapshot.center
        center.y = location.y
        snapshot.center = center
        
        // Is destination valid and is it different from source?
        if (indexPath != sourceIndexPath
            && indexPath.row != interactor.viewModel?.tasks.count ?? 0) {
            
            // ... update data source.
            let request = MoveTask.Request(fromIndex: indexPath.row, toIndex: sourcePath.row)
            interactor.moveTask(withRequest: request)
            self.tableView.moveRow(at: sourcePath, to: indexPath)
            sourceIndexPath = indexPath
        }
    }
    
    func didFinishMovingTask(to location: CGPoint) {
        guard let sourcePath = sourceIndexPath,
              let indexPath = tableView.indexPathForRow(at: location),
              let snapshot = snapshot,
              let cell = tableView.cellForRow(at: sourcePath)
        else {
            return
        }
        cell.isHidden = false
        cell.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            snapshot.center = cell.center
            snapshot.transform = CGAffineTransform.identity
            snapshot.alpha = 0
            cell.alpha = 1
            
        }, completion: { completed in
            self.sourceIndexPath = nil;
            self.snapshot?.removeFromSuperview()
            self.snapshot = nil;
            
            let request = MoveTask.Request(fromIndex: indexPath.row, toIndex: sourcePath.row)
            self.interactor.moveTask(withRequest: request)
        })
    }
}



// MARK: Table Data Source

extension ListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (interactor.viewModel?.tasks.count ?? 0) + 1  // +1 to account for new task cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isExistingTask = indexPath.row < interactor.viewModel?.tasks.count ?? 0
        let cell = isExistingTask ? makeTaskCell(at: indexPath) : makeNewTaskCell()
        cell.selectionStyle = .none
        cell.backgroundColor = Theme.current.colorTheme.primaryLight
        return cell
    }
}


// MARK: Cell Factory

extension ListViewController {
    
    func makeTaskCell(at indexPath: IndexPath) ->  UITableViewCell {
        let reuseId = "list_item"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? TaskTableViewCell
            ?? TaskTableViewCell(reuseId: reuseId)
        let isChecked = interactor.viewModel?.tasks[indexPath.row].isChecked ?? false
        let selector = #selector(didTapCheckButton(_:))
        cell.checkButton.addTarget(self, action: selector, for: .touchUpInside)
        cell.checkButton.isChecked = isChecked
        cell.textField.placeholder = nil
        cell.textField.text = interactor.viewModel?.tasks[indexPath.row].text
        cell.textField.delegate = self
        cell.textField.textColor = isChecked ? UIColor.lightGray : UIColor.black
        cell.textField.tag = FieldType.task.rawValue
        cell.textField.textColor = Theme.current.colorTheme.primaryText
        return cell
    }
    
    func makeNewTaskCell() -> UITableViewCell {
        let reuseId = "new_item"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? NewTaskTableViewCell
            ?? NewTaskTableViewCell(reuseId: reuseId)
        cell.textField.text = nil
        cell.textField.placeholder = "Add new task.."
        cell.textField.delegate = self
        cell.textField.textColor = Theme.current.colorTheme.primaryText
        cell.textField.tag = FieldType.task.rawValue
        
        // TODO: Use third pary framework placeholder color, this is a temporary hack
        cell.textField.setValue(Theme.current.colorTheme.secondaryText, forKeyPath: "_placeholderLabel.textColor")
        return cell
    }
}

// MARK: Helper Functions

extension ListViewController {
    
    /**
        Used when user taps delete button
     */
    func deleteTask(at indexPath: IndexPath) {
        tableView.beginUpdates()
        let request = DeleteTask.Request(index: indexPath.row)
        interactor.deleteTask(withRequest: request)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    /**
        Inserts a row above the add task cell via copying the data. Then
        the add task cell is cleared and focus is shifted without notice.
     */
    func addTask(withText text: String, completionHandler: @escaping () -> ()) {
        let nextIndexPath = IndexPath(row: interactor.viewModel?.tasks.count ?? 0, section: 0)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionHandler)
        tableView.beginUpdates()
        let request = AddTask.Request(description: text)
        interactor.addTask(withRequest: request)
        tableView.insertRows(at: [nextIndexPath], with: .none)
        
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    func toggleChecked(at indexPath: IndexPath) {
        let isChecked = interactor.viewModel?.tasks[indexPath.row].isChecked ?? false
        let request = CheckTask.Request(index: indexPath.row, isChecked: !isChecked)
        interactor.checkTask(withRequest: request)
        
        
        // If the cell is visible, do no reload so we dont lose focuse
        // Otherwise reload
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            cell.checkButton.isChecked = !isChecked
        } else {
            tableView.reloadData()
        }
    }
}


// MARK: Table Delegate

extension ListViewController {
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            self.deleteTask(at: indexPath)
        }
        action.backgroundColor = UIColor.red
        return [action]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return interactor.viewModel?.tasks.count ?? 0 != indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return interactor.viewModel?.tasks.count ?? 0 != indexPath.row
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let request = MoveTask.Request(fromIndex: sourceIndexPath.row,
                                       toIndex: destinationIndexPath.row)
        interactor.moveTask(withRequest: request)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


// MARK: UITextField Delegate

extension ListViewController: UITextFieldDelegate {
    
    private func textFieldShouldReturn(forTask textField: UITextField) -> Bool {
        // Assert the task is valid
        let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        guard let indexPath = tableView.indexPath(forElement: textField), text != "" else {
            return false
        }
        
        // Check if its a new task
        guard indexPath.row < interactor.viewModel?.tasks.count ?? 0 else {
            textField.text = nil  // Clear new task cell now that user is done
            addTask(withText: text, completionHandler: focusKeyboardOnNewTask)
            return false
        }
        
        if interactor.viewModel?.tasks[indexPath.row].text != text {
            let request = UpdateTaskDescription.Request(index: indexPath.row, description: text)
            interactor.updateTaskDescription(withRequest: request)
        }
        textField.resignFirstResponder()
        return false
    }
    
    func clearNewTaskCell() {
        let indexPath = IndexPath(row: interactor.viewModel?.tasks.count ?? 0, section: 0)
        let addTaskCell = self.tableView.cellForRow(at: indexPath) as? NewTaskTableViewCell
        addTaskCell?.textField.text = nil
    }
    
    private func textFieldShouldReturn(forTitle textField: UITextField) -> Bool {
        let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        guard text != "" else {
            return false
        }
        let request = UpdateListName.Request(name: text)
        interactor.updateListName(witRequest: request)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Identify the text field type
        guard let fieldType = FieldType(rawValue: textField.tag) else {
            return false
        }
        
        switch fieldType {
        case .task:
            return textFieldShouldReturn(forTask: textField)
        case .title:
            return textFieldShouldReturn(forTitle: textField)
        }
    }
}


extension ListViewController: ListViewControllerInput {
    
    func presentFetchListResponse(_ response: FetchList.Response) {
        switch response {
        case .succcess:
            listTitleTextField?.text = interactor.viewModel?.title
            tableView.reloadData()
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func presentAddTaskResponse(_ response: AddTask.Response) {
        switch response {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func presentDeleteTaskResponse(_ response: DeleteTask.Response) {
        switch response {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func presentMoveTaskResponse(_ response: MoveTask.Response) {
        switch response {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func presentCheckTaskResponse(_ response: CheckTask.Response) {
        switch response {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func presentUpdateListNameReponse(_ response: UpdateListName.Response) {
        switch response {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
    
    func presentUpdateTaskDescriptionResponse(_ response: UpdateTaskDescription.Response) {
        switch response {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: error.localizedDescription)
        }
    }
}

