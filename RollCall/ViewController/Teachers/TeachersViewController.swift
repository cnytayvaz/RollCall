//
//  TeachersViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 13.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class TeachersViewController: BaseViewController {
    
    enum PageMode {
        case view
        case edit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with pageMode: PageMode = .view) {
        self.pageMode = pageMode
        super.init(nibName: nil, bundle: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
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
        
        if pageMode == .edit {
            prepareBarButtonItems()
            let longPressTableViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongPress(gesture:)))
            tableView.addGestureRecognizer(longPressTableViewGesture)
        }

        // Do any additional setup after loading the view.
        users.append(User(id: 0, tc: "100", no: "100", name: "Cüneyt AYVAZ", phone: "0545 000 00 00", selected: false))
        users.append(User(id: 0, tc: "101", no: "101", name: "Ozan DAMCI", phone: "0545 000 00 00", selected: false))
        users.append(User(id: 0, tc: "102", no: "102", name: "Akif DEMİREZEN", phone: "0545 000 00 00", selected: false))
        users.append(User(id: 0, tc: "103", no: "103", name: "MUSTAFA KOCADAĞ", phone: "0545 000 00 00", selected: false))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        tableView.register(TeacherTableViewCell.nib, forCellReuseIdentifier: TeacherTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setText() {
        title = "Öğretmenler".localized()
        searchController.searchBar.placeholder = "Ara".localized()
    }
    
    override func viewWillLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
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
        let deletedItems = users.filter({ item -> Bool in
            item.selected && item.id != 0
        })
        deletedUsers.append(contentsOf: deletedItems)
        users = users.filter({ item -> Bool in
            !item.selected
        })
    }
    
    @objc func addBarButtonItemTapped() {
        
        let alert = UIAlertController(title: "Yeni Öğretmen".localized(), message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Öğretmen Tc Kimlik No".localized()
        }
        alert.addTextField { textField in
            textField.placeholder = "Öğretmen Adı".localized()
        }
        alert.addTextField { textField in
            textField.placeholder = "Öğretmen Tel".localized()
        }
        
        let button = UIAlertAction(title: "Tamam".localized(), style: .default) { _ in
            let newUserTc = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserName = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserPhone = alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if newUserTc.isEmpty {
                self.showAlert(message: "Öğretmen Tc Kimlik No boş olmamalı.".localized())
                return
            }
            
            if newUserName.isEmpty {
                self.showAlert(message: "Öğretmen ismi boş olmamalı.".localized())
                return
            }
            
            if newUserPhone.isEmpty {
                self.showAlert(message: "Öğretmen telefon numarası boş olmamalı.".localized())
                return
            }
            
            if !self.users.filter({ item -> Bool in
                item.tc.lowercased() == newUserTc.lowercased()
            }).isEmpty {
                self.showAlert(message: "Bu Tc Kimlik Numarası zaten var.".localized())
                return
            }
            
            self.users.append(User(id: 0, tc: newUserTc, no: "", name: newUserName, phone: newUserPhone, selected: false))
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
        for i in 0..<users.count {
            users[i].selected = false
        }
    }
    
    @objc func tableViewLongPress(gesture: UILongPressGestureRecognizer!) {
        if selectionEnabled {
            return
        }
        
        let point = gesture.location(in: self.tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        let index = findArrayIndex(indexPath)
        selectionEnabled = true
        users[index].selected = !users[index].selected
    }
    
    func editUser(arrayIndex: Int) {
        
        let alert = UIAlertController(title: "Öğretmen Düzenle".localized(), message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Öğretmen Tc Kimlik No".localized()
            textField.text = self.users[arrayIndex].tc
            textField.isEnabled = false
        }
        alert.addTextField { textField in
            textField.placeholder = "Öğretmen Adı".localized()
            textField.text = self.users[arrayIndex].name
        }
        alert.addTextField { textField in
            textField.placeholder = "Öğretmen Tel".localized()
            textField.text = self.users[arrayIndex].phone
        }
        
        let button = UIAlertAction(title: "Tamam".localized(), style: .default) { _ in
            let newUserTc = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserName = alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let newUserPhone = alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if newUserTc.isEmpty {
                self.showAlert(message: "Öğretmen Tc Kimlik No boş olmamalı.".localized())
                return
            }
            
            if newUserName.isEmpty {
                self.showAlert(message: "Öğretmen ismi boş olmamalı.".localized())
                return
            }
            
            if newUserPhone.isEmpty {
                self.showAlert(message: "Öğretmen telefon numarası boş olmamalı.".localized())
                return
            }
            
            if !self.users.filter({ item -> Bool in
                item.tc.lowercased() == newUserTc.lowercased()
            }).isEmpty {
                self.showAlert(message: "Bu Tc Kimlik Numarası zaten var.".localized())
                return
            }
            self.users[arrayIndex].tc = newUserTc
            self.users[arrayIndex].name = newUserName
            self.users[arrayIndex].phone = newUserPhone
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
        filteredUsers = users.filter({( item: User) -> Bool in
            item.name.lowercased().contains(searchText.lowercased())
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

extension TeachersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = findArrayIndex(indexPath)
        switch pageMode {
        case .view:
            break
        case .edit:
            if selectionEnabled {
                users[index].selected = !users[index].selected
            }
            else {
                editUser(arrayIndex: index)
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherTableViewCell.identifier, for: indexPath) as! TeacherTableViewCell
        cell.configure(with: users[index])
        return cell
    }
}

extension TeachersViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}
