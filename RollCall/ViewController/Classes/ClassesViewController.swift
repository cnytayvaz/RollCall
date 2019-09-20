//
//  ClassesViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

struct Classroom {
    var id = 0
    var name = ""
    var selected = false
}

protocol ClassSelectionDelegate {
    func didSelect(class: Classroom)
    func didSelect(classes: [Classroom])
}

extension ClassSelectionDelegate {
    
    func didSelect(class: Classroom) { }
    
    func didSelect(classes: [Classroom]) { }
}

class ClassesViewController: BaseViewController {
    
    enum PageMode {
        case view
        case edit
        case singleSelection
        case multiSelection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with pageMode: PageMode = .view, target: ClassSelectionDelegate? = nil) {
        self.pageMode = pageMode
        self.delegate = target
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let ROW_ITEM_COUNT = 3
    let ITEM_SPACE = 8
    
    var delegate: ClassSelectionDelegate?
    
    var pageMode = PageMode.view
    var selectionEnabled = false {
        didSet {
            if selectionEnabled {
                navigationItem.rightBarButtonItem = cancelBarButton
            }
            else {
                navigationItem.rightBarButtonItem = selectBarButton
            }
            if addBarButton != nil {
                addBarButton.isEnabled = !selectionEnabled
            }
        }
    }
    var searchText = ""
    
    var editBarButton: UIBarButtonItem!
    var doneBarButton: UIBarButtonItem!
    var flexibleSpace: UIBarButtonItem!
    var deleteBarButton: UIBarButtonItem!
    var addBarButton: UIBarButtonItem!
    var selectBarButton: UIBarButtonItem!
    var cancelBarButton: UIBarButtonItem!
    
    var classes: [Classroom] = [] {
        didSet {
            if isFiltering() {
                filteredClasses = self.classes.filter({( item: Classroom) -> Bool in
                    item.name.lowercased().contains(searchText.lowercased())
                })
            }
            if deleteBarButton != nil {
                deleteBarButton.isEnabled = !self.classes.filter({ item -> Bool in
                    item.selected
                }).isEmpty
            }
            if !isFiltering() {
                collectionView.reloadData()
            }
        }
    }
    
    var filteredClasses: [Classroom] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var deletedClasses: [Classroom] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pageMode == .edit {
            prepareBarButtonItems()
            let longPressCollectionViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(collectionViewLongPress(gesture:)))
            collectionView.addGestureRecognizer(longPressCollectionViewGesture)
        }
        
        classes.append(Classroom(id: 0, name: "12 Fen - A", selected: false))
        classes.append(Classroom(id: 0, name: "12 Fen - B", selected: false))
        classes.append(Classroom(id: 0, name: "12 Fen - C", selected: false))
        classes.append(Classroom(id: 0, name: "12 Fen - D", selected: false))
        classes.append(Classroom(id: 0, name: "12 Fen - E", selected: false))
        classes.append(Classroom(id: 0, name: "12 TM - A", selected: false))
        
        classes.append(Classroom(id: 0, name: "11 Fen - A", selected: false))
        classes.append(Classroom(id: 0, name: "11 Fen - B", selected: false))
        classes.append(Classroom(id: 0, name: "11 Fen - C", selected: false))
        classes.append(Classroom(id: 0, name: "11 Fen - D", selected: false))
        classes.append(Classroom(id: 0, name: "11 Fen - E", selected: false))
        classes.append(Classroom(id: 0, name: "11 TM - A", selected: false))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        collectionView.register(ClassCollectionViewCell.nib, forCellWithReuseIdentifier: ClassCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setText() {
        title = "Sınıflar".localized()
        searchController.searchBar.placeholder = "Ara".localized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if pageMode == .edit {
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    func prepareBarButtonItems() {
        selectBarButton = UIBarButtonItem(title: "Seç".localized(), style: .plain, target: self, action: #selector(selectBarButtonItemTapped))
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonItemTapped))
        deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonItemTapped))
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped))
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonItemTapped))
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        navigationItem.rightBarButtonItem = selectBarButton
        setToolbarItems([deleteBarButton, flexibleSpace, addBarButton, flexibleSpace, doneBarButton], animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc func doneBarButtonItemTapped() {
        popViewController()
    }
    
    @objc func deleteBarButtonItemTapped() {
        selectionEnabled = false
        let deletedItems = classes.filter({ item -> Bool in
            item.selected && item.id != 0
        })
        deletedClasses.append(contentsOf: deletedItems)
        classes = classes.filter({ item -> Bool in
            !item.selected
        })
    }
    
    @objc func addBarButtonItemTapped() {
        
        let alert = UIAlertController(title: "Yeni Sınıf".localized(), message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Sınıf".localized()
        }
        
        let button = UIAlertAction(title: "Tamam".localized(), style: .default) { _ in
            let newClassName = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if newClassName.isEmpty {
                self.showAlert(message: "Sınıf ismi boş olmamalı.".localized())
                return
            }
            
            if !self.classes.filter({ item -> Bool in
                item.name.lowercased() == newClassName.lowercased()
            }).isEmpty {
                self.showAlert(message: "Bu isimde bir sınıf zaten var.".localized())
                return
            }
            
            self.classes.append(Classroom(id: 0, name: newClassName, selected: false))
        }
        
        alert.addAction(button)
        
        let cancelButton = UIAlertAction(title: "İptal".localized(), style: .cancel) { _ in
            
        }
        alert.addAction(cancelButton)
        presentViewController(viewController: alert)
    }
    
    @objc func selectBarButtonItemTapped() {
        selectionEnabled = true
    }
    
    @objc func cancelBarButtonItemTapped() {
        selectionEnabled = false
        for i in 0..<classes.count {
            classes[i].selected = false
        }
    }
    
    @objc func collectionViewLongPress(gesture: UILongPressGestureRecognizer!) {
        if selectionEnabled {
            return
        }
        
        let point = gesture.location(in: self.collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        let index = findArrayIndex(indexPath)
        selectionEnabled = true
        classes[index].selected = !classes[index].selected
    }
    
    func editClass(arrayIndex: Int) {
        let alert = UIAlertController(title: "Sınıf Düzenle".localized(), message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Sınıf Adı".localized()
            textField.text = self.classes[arrayIndex].name
        }
        
        let button = UIAlertAction(title: "Tamam".localized(), style: .default) { _ in
            let newClassName = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if newClassName.isEmpty {
                self.showAlert(message: "Sınıf ismi boş olmamalı.".localized())
                return
            }
            
            if !self.classes.filter({ item -> Bool in
                item.name.lowercased() == newClassName.lowercased()
            }).isEmpty {
                self.showAlert(message: "Bu isimde bir sınıf zaten var.".localized())
                return
            }
            self.classes[arrayIndex].name = newClassName
        }
        
        alert.addAction(button)
        
        let cancelButton = UIAlertAction(title: "İptal".localized(), style: .cancel) { _ in
            
        }
        alert.addAction(cancelButton)
        presentViewController(viewController: alert)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.searchText = searchText
        filteredClasses = classes.filter({( item: Classroom) -> Bool in
            item.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func findArrayIndex(_ indexPath: IndexPath) -> Int {
        if isFiltering() {
            let classroom = filteredClasses[(indexPath.section * ROW_ITEM_COUNT) + indexPath.row]
            return findItemIndexInArray(classroom) ?? 0
        }
        
        return (indexPath.section * ROW_ITEM_COUNT) + indexPath.row
    }
    
    func findItemIndexInArray(_ classroom: Classroom) -> Int? {
        for i in 0..<classes.count {
            if classroom.name == classes[i].name {
                return i
            }
        }
        return nil
    }
    
}

extension ClassesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = findArrayIndex(indexPath)
        switch pageMode {
        case .view:
            let viewController = ClassDetailViewController()
            pushViewController(viewController: viewController)
        case .edit:
            if selectionEnabled {
                classes[index].selected = !classes[index].selected
            }
            else {
                editClass(arrayIndex: index)
            }
        case .singleSelection:
            delegate?.didSelect(class: classes[index])
        case .multiSelection:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredClasses.count
        }
        return classes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = findArrayIndex(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCollectionViewCell.identifier, for: indexPath) as! ClassCollectionViewCell
        cell.configure(with: classes[index])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width - CGFloat(integerLiteral: ((ROW_ITEM_COUNT - 1) * ITEM_SPACE))) / CGFloat(integerLiteral: ROW_ITEM_COUNT)),
                      height: ((collectionView.frame.size.width - CGFloat(integerLiteral: ((ROW_ITEM_COUNT - 1) * ITEM_SPACE))) / CGFloat(integerLiteral: ROW_ITEM_COUNT)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(integerLiteral: ITEM_SPACE)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(integerLiteral: ITEM_SPACE)
    }
    
}

extension ClassesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}
