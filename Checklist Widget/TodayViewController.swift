//
//  TodayViewController.swift
//  Checklist Widget
//
//  Created by Andrew Johnson on 12/10/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var list: List?
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        guard let list = Database.getPrimaryList() else {
//            completionHandler(.noData)
//            return
//        }
        self.list = List()//list
        let tasks = [Item(), Item(), Item()]
        self.list?.tasks = tasks
        tableView.reloadData()
        completionHandler(.newData)
    }
    
    func toggleCheckmark(at indexPath: IndexPath) {
        guard var task = list?.tasks[indexPath.row] else {
            return
        }
        task.isChecked = !task.isChecked
        updateTask(at: indexPath, to: task, reload: true)
    }
    
    func updateTask(at indexPath: IndexPath, to task: Item, reload: Bool = false) {
        guard list != nil else {
            return
        }
        tableView.beginUpdates()
        list!.tasks[indexPath.row] = task
        if reload { tableView.reloadRows(at: [indexPath], with: .automatic) }
        tableView.endUpdates()
        //Database.save(list: list!)
    }
}


extension TodayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "list_item"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? TaskTableViewCell
            ?? TaskTableViewCell(reuseId: reuseId)
        let item = list?.tasks[indexPath.row] ?? Item()
        let image = item.isChecked ? UIImage.checked : UIImage.unchecked
        cell.checkButton.setImage(image, for: .normal)
        cell.textField.text = item.text
        cell.textField.isUserInteractionEnabled = false
        return cell
    }
}


extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toggleCheckmark(at: indexPath)
    }
}
