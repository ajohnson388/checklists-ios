//
//  ListCollectionViewCell.swift
//  Checklist
//
//  Created by Andrew Johnson on 12/26/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var list: List? {
        didSet {
            setup()
        }
    }
    var scale: CGFloat = 1 {
        didSet {
            setup()
        }
    }
    //let blurView = UIVisualEffectView(effect: UIBlurEffect.init(style: UIBlurEffectStyle.dark))
    let tableView = UITableView(frame: CGRect.null, style: .plain)
    let shadow = UIView(frame: CGRect.null)
    
    override var isHighlighted: Bool {
        didSet {
            tableView.alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.null)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    // MARK: Setup
    
    fileprivate func setup() {
        addViews()
        configureViews()
        applyAutoLayoutConstraints()
        tableView.reloadData()
    }
    
    fileprivate func addViews() {
        if !contentView.subviews.contains(tableView) {
            contentView.addSubview(tableView)
        }
    }
    
    fileprivate func configureViews() {
        tableView.isUserInteractionEnabled = false
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Theme.current.colorTheme.primaryLight
        tableView.separatorStyle = .none
        tableView.layer.borderColor = Theme.current.colorTheme.secondaryLight.cgColor
        tableView.layer.borderWidth = 0.5
    }
    
    fileprivate func applyAutoLayoutConstraints() {
        // Define constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}


// MARK: Table DataSource

extension ListCollectionViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Only show a preview of the tasks, set a cap
        let maxCount = 10
        let count = list?.tasks.count ?? 0
        return count > maxCount ? maxCount : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "taskPreviewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? TaskPreviewTableViewCell
            ?? TaskPreviewTableViewCell(reuseId: reuseId)
        let task = list?.tasks[indexPath.row]
        let isChecked = task?.isChecked ?? false
        cell.checkButton.isChecked = isChecked
        cell.checkButton.isUserInteractionEnabled = false
        cell.taskLabel.text = task?.text
        cell.taskLabel.textColor = isChecked ? UIColor.lightGray : UIColor.black
        cell.scale = scale
        cell.taskLabel.textColor = Theme.current.colorTheme.primaryText
        cell.selectionStyle = .none
        cell.backgroundColor = Theme.current.colorTheme.primaryLight
        return cell
    }
}


// MARK: Table View Delegate

extension ListCollectionViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 * scale
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
