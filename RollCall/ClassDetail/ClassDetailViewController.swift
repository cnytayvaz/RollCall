//
//  ClassDetailViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

struct User {
    var no = ""
    var name = ""
    var state = true
}

class ClassDetailViewController: BaseViewController {

    @IBOutlet weak var tableViewUsersLabel: UILabel!
    @IBOutlet weak var tableViewUsers: UITableView!
    @IBOutlet weak var tableViewUsersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewAbsentUsersLabel: UILabel!
    @IBOutlet weak var tableViewAbsentUsers: UITableView!
    @IBOutlet weak var tableViewAbsentUsersHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    
    var users: [User] = [] {
        didSet {
            tableViewUsers.reloadData()
            tableViewUsersHeightConstraint.constant = tableViewUsers.contentSize.height
        }
    }
    var filteredUsers: [User] = [] {
        didSet {
            tableViewUsers.reloadData()
            tableViewUsersHeightConstraint.constant = tableViewUsers.contentSize.height
        }
    }
    var absentUsers: [User] = [] {
        didSet {
            tableViewAbsentUsers.reloadData()
            tableViewAbsentUsersHeightConstraint.constant = tableViewAbsentUsers.contentSize.height
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users.append(User(no: "100", name: "Cüneyt AYVAZ", state: true))
        users.append(User(no: "101", name: "Ozan DAMCI", state: true))
        users.append(User(no: "102", name: "Akif DEMİREZEN", state: true))
        users.append(User(no: "103", name: "MUSTAFA KOCADAĞ", state: true))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Class"
        navigationItem.searchController = searchController
        
        tableViewUsers.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableViewUsers.delegate = self
        tableViewUsers.dataSource = self
        
        tableViewAbsentUsers.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableViewAbsentUsers.delegate = self
        tableViewAbsentUsers.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        tableViewUsersHeightConstraint.constant = tableViewUsers.contentSize.height
        tableViewAbsentUsersHeightConstraint.constant = tableViewAbsentUsers.contentSize.height
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter({( item: User) -> Bool in
            return String(format: "%@ %@", item.no, item.name).lowercased().contains(searchText.lowercased())
        })
    }
}

extension ClassDetailViewController: UserTableViewCellDelegate {
    func userRollCallButtonTapped(user: User) {
        if user.state && !absentUsers.contains(where: { item -> Bool in
            item.no == user.no
        }) {
            var absentUser = user
            absentUser.state = false
            absentUsers.append(absentUser)
        }
        else if !user.state {
            absentUsers.removeAll { item -> Bool in
                item.no == user.no
            }
        }
    }
}

extension ClassDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableViewUsers:
            if isFiltering() {
                return filteredUsers.count
            }
            else {
                return users.count
            }
        case tableViewAbsentUsers:
            return absentUsers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableViewUsers:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            
            if isFiltering() {
                cell.configure(with: filteredUsers[indexPath.row], delegate: self)
            }
            else {
                cell.configure(with: users[indexPath.row], delegate: self)
            }
            
            return cell
        case tableViewAbsentUsers:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            cell.configure(with: absentUsers[indexPath.row], delegate: self)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ClassDetailViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}
