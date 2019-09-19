//
//  ClassDetailViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

struct User {
    var id = 0
    var tc = ""
    var no = ""
    var name = ""
    var phone = ""
    var selected = false
}

class ClassDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var pageMode = PageMode.view
    var searchText = ""
    
    var editBarButton: UIBarButtonItem!
    var doneBarButton: UIBarButtonItem!
    var flexibleSpace: UIBarButtonItem!
    var deleteBarButton: UIBarButtonItem!
    var addBarButton: UIBarButtonItem!
    var selectBarButton: UIBarButtonItem!
    var cancelBarButton: UIBarButtonItem!
    
    var users: [User] = [] {
        didSet {
            if isFiltering() {
                filteredUsers = self.users.filter({( item: User) -> Bool in
                    item.name.lowercased().contains(searchText.lowercased())
                })
            }
            if deleteBarButton != nil {
                deleteBarButton.isEnabled = !self.users.filter({ item -> Bool in
                    item.selected
                }).isEmpty
            }
            if !isFiltering() {
                tableView.reloadData()
                tableViewHeightConstraint.constant = tableView.contentSize.height
            }
        }
    }
    var filteredUsers: [User] = [] {
        didSet {
            tableView.reloadData()
            tableViewHeightConstraint.constant = tableView.contentSize.height
        }
    }
    var deletedUsers: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users.append(User(id: 0, tc: "100", no: "100", name: "Cüneyt AYVAZ", phone: "0545 000 00 00", selected: false))
        users.append(User(id: 0, tc: "101", no: "101", name: "Ozan DAMCI", phone: "0545 000 00 00", selected: false))
        users.append(User(id: 0, tc: "102", no: "102", name: "Akif DEMİREZEN", phone: "0545 000 00 00", selected: false))
        users.append(User(id: 0, tc: "103", no: "103", name: "MUSTAFA KOCADAĞ", phone: "0545 000 00 00", selected: false))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        tableView.register(StudentTableViewCell.nib, forCellReuseIdentifier: StudentTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        prepareBarButtonItems()
    }
    
    override func setText() {
        title = "Öğrenciler".localized()
        searchController.searchBar.placeholder = "Ara".localized()
    }
    
    override func viewWillLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
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
        let deletedItems = users.filter({ item -> Bool in
            item.selected && item.id != 0
        })
        deletedUsers.append(contentsOf: deletedItems)
        users = users.filter({ item -> Bool in
            !item.selected
        })
    }
    
    @objc func addBarButtonItemTapped() {
        
        let alert = UIAlertController(title: "Yeni Öğrenci".localized(), message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Öğrenci Tc Kimlik No".localized()
        }
        alert.addTextField { textField in
            textField.placeholder = "Öğrenci No".localized()
        }
        alert.addTextField { textField in
            textField.placeholder = "Öğrenci Adı".localized()
        }
        alert.addTextField { textField in
            textField.placeholder = "Veli Tel".localized()
        }
        
        let button = UIAlertAction(title: "Tamam".localized(), style: .default) { _ in
            let newUserTc = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserNo = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserName = alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserPhone = alert.textFields?[3].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if newUserTc.isEmpty {
                self.showAlert(message: "Öğrenci Tc Kimlik No boş olmamalı.".localized())
                return
            }
            
            if newUserNo.isEmpty {
                self.showAlert(message: "Öğrenci No boş olmamalı.".localized())
                return
            }
            
            if newUserName.isEmpty {
                self.showAlert(message: "Öğrenci ismi boş olmamalı.".localized())
                return
            }
            
            if newUserPhone.isEmpty {
                self.showAlert(message: "Veli telefon numarası boş olmamalı.".localized())
                return
            }
            
            if !self.users.filter({ item -> Bool in
                item.tc.lowercased() == newUserTc.lowercased()
            }).isEmpty {
                self.showAlert(message: "Bu TC Kimlik Numarası zaten var.".localized())
                return
            }
            
            if !self.users.filter({ item -> Bool in
                item.no.lowercased() == newUserNo.lowercased()
            }).isEmpty {
                self.showAlert(message: "Bu numarada bir öğrenci zaten var.".localized())
                return
            }
            
            self.users.append(User(id: 0, tc: newUserTc, no: newUserNo, name: newUserName, phone: newUserPhone, selected: false))
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
        for i in 0..<users.count {
            users[i].selected = false
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
        filteredUsers = users.filter({( item: User) -> Bool in
            String(format: "%@ %@", item.no, item.name).lowercased().contains(searchText.lowercased())
        })
    }
    
    func findArrayIndex(_ indexPath: IndexPath) -> Int {
        if isFiltering() {
            let user = filteredUsers[indexPath.row]
            return findItemIndexInArray(user) ?? 0
        }
        
        return indexPath.row
    }
    
    func findItemIndexInArray(_ user: User) -> Int? {
        for i in 0..<users.count {
            if user.tc == users[i].tc {
                return i
            }
        }
        return nil
    }
}

extension ClassDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch pageMode {
        case .view:
            break
        case .select:
            let index = findArrayIndex(indexPath)
            users[index].selected = !users[index].selected
        case .edit:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = findArrayIndex(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.identifier, for: indexPath) as! StudentTableViewCell
        cell.configure(with: users[index])
        return cell
    }
}

extension ClassDetailViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}
