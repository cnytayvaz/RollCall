//
//  SelectSchoolViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 11.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

struct School {
    var name = ""
}

protocol SelectSchoolDelegate {
    func didSelect(school: School)
}

class SelectSchoolViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: SelectSchoolDelegate?
    
    var schools: [School] = [] {
        didSet {
            tableView.reloadData()
            tableViewHeightConstraint.constant = tableView.contentSize.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schools.append(School(name: "Keşap Anadolu Öğretmen Lisesi"))
        schools.append(School(name: "Topkapı Esenyurt"))
        schools.append(School(name: "Çamlıca Lisesi"))
        schools.append(School(name: "Keşap Anadolu Öğretmen Lisesi"))
        schools.append(School(name: "Topkapı Esenyurt"))
        schools.append(School(name: "Çamlıca Lisesi"))
        schools.append(School(name: "Keşap Anadolu Öğretmen Lisesi"))
        schools.append(School(name: "Topkapı Esenyurt"))
        schools.append(School(name: "Çamlıca Lisesi"))
        schools.append(School(name: "Keşap Anadolu Öğretmen Lisesi"))
        schools.append(School(name: "Topkapı Esenyurt"))
        schools.append(School(name: "Çamlıca Lisesi"))
        schools.append(School(name: "Keşap Anadolu Öğretmen Lisesi"))
        schools.append(School(name: "Topkapı Esenyurt"))
        schools.append(School(name: "Çamlıca Lisesi"))

        // Do any additional setup after loading the view.
        tableView.register(SchoolTableViewCell.nib, forCellReuseIdentifier: SchoolTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func isNavigationBarHidden() -> Bool {
        return true
    }
    
    override func isBackActionEnabled() -> Bool {
        return false
    }
    
    override func viewWillLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
}

extension SelectSchoolViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.identifier, for: indexPath) as! SchoolTableViewCell
        cell.configure(with: schools[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSchool = schools[indexPath.row]
        delegate?.didSelect(school: selectedSchool)
        dismissViewController()
    }
}
