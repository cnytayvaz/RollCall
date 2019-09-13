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

class ClassesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let ROW_ITEM_COUNT = 3
    let ITEM_SPACE = 8
    
    var pageMode = PageMode.view
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
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        collectionView.register(ClassCollectionViewCell.nib, forCellWithReuseIdentifier: ClassCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        prepareBarButtonItems()
    }
    
    override func setText() {
        title = "Sınıflar".localized()
        searchController.searchBar.placeholder = "Ara".localized()
    }
    
    func prepareBarButtonItems() {
        editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonItemTapped))
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonItemTapped))
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonItemTapped))
        deleteBarButton.isEnabled = false
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped))
        selectBarButton = UIBarButtonItem(title: "Seç".localized(), style: .plain, target: self, action: #selector(selectBarButtonItemTapped))
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    @objc func editBarButtonItemTapped() {
        pageMode = .edit
        navigationItem.rightBarButtonItem = doneBarButton
        setToolbarItems([addBarButton, flexibleSpace, selectBarButton], animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc func doneBarButtonItemTapped() {
        pageMode = .view
        navigationItem.rightBarButtonItem = editBarButton
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func deleteBarButtonItemTapped() {
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
        pageMode = .select
        navigationItem.rightBarButtonItem = nil
        setToolbarItems([deleteBarButton, flexibleSpace, cancelBarButton], animated: true)
    }
    
    @objc func cancelBarButtonItemTapped() {
        pageMode = .edit
        navigationItem.rightBarButtonItem = doneBarButton
        deleteBarButton.isEnabled = false
        setToolbarItems([addBarButton, flexibleSpace, selectBarButton], animated: true)
        for i in 0..<classes.count {
            classes[i].selected = false
        }
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
        switch pageMode {
        case .view:
            let viewController = ClassDetailViewController()
            pushViewController(viewController: viewController)
        case .select:
            let index = findArrayIndex(indexPath)
            classes[index].selected = !classes[index].selected
        case .edit:
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
