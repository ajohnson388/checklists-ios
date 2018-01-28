//
//  ListViewController.swift
//  Checklist
//
//  Created by Andrew Johnson on 11/26/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class ListsViewController: UICollectionViewController {
    
    // MARK: Properties
    
    fileprivate static let listCellReuseId = "listCell"
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: nil, action: nil)
    let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                     target: nil, action: nil)
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                       target: nil, action: nil)
    let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                       target: nil, action: nil)
    let selectionCountLabel = UILabel(frame:
        CGRect(x: 0, y: 0, width: 55, height: 44))
    
    var interactor: ListsViewControllerOutput!
    var router: ListsViewControllerRouterInput!
    
    var isCollectionViewEditing: Bool = false
    
    
    // MARK: Object Lifecycle
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListsViewConfigurator.configure(viewController: self)
        setupBarItems()
        setupNavBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchLists(withRequest: FetchLists.Request())
        collectionView?.reloadData()
        setEmpty(interactor.viewModel?.lists.count ?? 0 == 0)
    }
    
    
    // MARK: Setup
    
    func setupBarItems() {
        addButton.target = self
        addButton.action = #selector(addButtonTapped(_:))
        
        editButton.target = self
        editButton.action = #selector(editButtonTapped(_:))
        
        cancelButton.target = self
        cancelButton.action = #selector(editButtonTapped(_:))
        
        deleteButton.target = self
        deleteButton.action = #selector(deleteButtonTapped(_:))
        
        selectionCountLabel.textColor =
            Theme.current.colorTheme.secondaryText
        selectionCountLabel.textAlignment = .right
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
        navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain,
                            target: nil, action: nil)
        navigationItem.title = "Checklists"
    }
    
    func setupCollectionView() {
        collectionView?.collectionViewLayout = makeCollectionViewLayout()
        collectionView?.backgroundColor = Theme.current.colorTheme.primaryDark
        collectionView?.allowsMultipleSelection = true
        collectionView?.register(ListCollectionViewCell.self,
            forCellWithReuseIdentifier: ListsViewController.listCellReuseId)
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let cellWidth = view.frame.size.width * 0.3
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8,
                                           bottom: 8, right: 8)
        layout.itemSize = CGSize(width: cellWidth,
                                 height: cellWidth * 2)
        return layout
    }
    
    
    // MARK: User Actions
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        router.openNewList()
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditing()
    }
    
    @objc func deleteButtonTapped(_ sender: UIBarButtonItem) {
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems ?? []
        let isAllLists = selectedIndexPaths.count
            == interactor.viewModel?.lists.count ?? 0
        let selectedLists = selectedIndexPaths.flatMap { interactor.viewModel?.lists[$0.row].id }
        
        let request = DeleteLists.Request(identifiers: Set(selectedLists))
        interactor.deleteLists(withRequest: request)
        
        collectionView?.deleteItems(at: selectedIndexPaths)
        if isAllLists {
            editButtonTapped(cancelButton)
            setEmpty(interactor.viewModel?.lists.count ?? 0 == 0)
        }
    }
    
    fileprivate func setBottomBarEditing(_ editing: Bool) {
        
    }
    
    fileprivate func setNavigationBarEditiing(_ editing: Bool) {
        
    }
    
    fileprivate func toggleEditing() {
        // Toggle state
        isCollectionViewEditing = !isCollectionViewEditing
        
        // Reset selection state
        deselectAllItems()
        
        // Hide or show the bottom toolbar
        navigationController?.setToolbarHidden(!isCollectionViewEditing,
                                               animated: true)
        
        // Assert the delete button is initially disabled
        deleteButton.isEnabled = false
        
        // Add or remove the delete button from the toolbar
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil, action: nil)
        navigationController?.toolbar.setItems(isCollectionViewEditing
            ? [space, deleteButton] : nil, animated: true)
        
        // Update components dependent on the selection count
        selectionCountDidChange()
        
        // Add and remove the appropriate navigation bar buttons
        navigationItem.setRightBarButton(isCollectionViewEditing
            ? UIBarButtonItem(customView: selectionCountLabel)
            : addButton, animated: true)
        navigationItem.setLeftBarButton(isCollectionViewEditing
            ? cancelButton : editButton, animated: true)
    }
    
    fileprivate func deselectAllItems() {
        guard let collectionView = collectionView else {
            return
        }
        let selectedIndexPaths = collectionView.indexPathsForSelectedItems ?? []
        for indexPath in selectedIndexPaths {
            collectionView.deselectItem(at: indexPath, animated: false)
            didSelectItem(false, for: collectionView, at: indexPath)
        }
    }
    
    fileprivate func selectionCountDidChange() {
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems ?? []
        deleteButton.isEnabled = selectedIndexPaths.count > 0
        selectionCountLabel.text = selectedIndexPaths.count > 0
            ? "\(selectedIndexPaths.count)" : ""
    }
    
    fileprivate func didSelectItem(_ didSelectItem: Bool,
                                   for collectionView: UICollectionView,
                                   at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell
        cell?.isHighlighted = didSelectItem
        selectionCountDidChange()
    }
    
    fileprivate func openItem(for collectionView: UICollectionView,
                              at indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let list = interactor.viewModel?.lists[indexPath.row] else {
            return
        }
        router.openList(withId: list.id)
    }
    
    fileprivate func setEmpty(_ shouldSetEmpty: Bool) {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundView = shouldSetEmpty
            ? EmptyTableView(frame: collectionView.bounds) : nil
        navigationItem.setLeftBarButton(shouldSetEmpty
            ? nil : editButton, animated: false)
    }
    
    
    // MARK: Collection Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return interactor.viewModel?.lists.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsViewController.listCellReuseId,
                                                      for: indexPath) as! ListCollectionViewCell
        cell.list = List()//viewModel!.lists[indexPath.row]
        cell.scale = 0.6
        cell.isHighlighted = false
        return cell
    }
    
    
    // MARK: Collection Delegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard isCollectionViewEditing else {
            openItem(for: collectionView, at: indexPath)
            return
        }
        didSelectItem(true, for: collectionView, at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didDeselectItemAt indexPath: IndexPath) {
        guard isCollectionViewEditing else {
            return
        }
        didSelectItem(false, for: collectionView, at: indexPath)
    }
}


extension ListsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}


extension ListsViewController: ListsViewControllerInput {
    
    /**
        After the interactor finishes proccessing the delete request, a new view model
        is generated and passed if successful. This model needs to be stored as reference
        for the
     */
    func presentDeleteResult(_ result: DeleteLists.Response) {
        switch result {
        case .success:
            break
        case .error(let error):
            router.presentErrorAlert(withMessage: 
                error.localizedDescription)
            break
        }
    }
    
    func presentFetchResult(_ result: FetchLists.Response) {
        // Update the view model and re-populate table
        switch result {
        case .Success:
            collectionView?.reloadData()
        case .Error(let error):
            router.presentErrorAlert(withMessage:
                error.localizedDescription)
        }
    }
}
