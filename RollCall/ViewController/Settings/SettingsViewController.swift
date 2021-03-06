//
//  SettingsViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 19.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

struct SettingItem {
    var id = 0
    var name = ""
}

class SettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let EDIT_CLASS = 0
    let EDIT_STUDENT = 1
    let EDIT_TEACHER = 2
    let CHANGE_PASSWORD = 3
    let CHANGE_LANGUAGE = 4
    
    var settingItems: [SettingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingItems.append(SettingItem(id: EDIT_CLASS, name: "Sınıfları Düzenle".localized()))
        settingItems.append(SettingItem(id: EDIT_STUDENT, name: "Öğrencileri Düzenle".localized()))
        settingItems.append(SettingItem(id: EDIT_TEACHER, name: "Öğretmenleri Düzenle".localized()))
        settingItems.append(SettingItem(id: CHANGE_PASSWORD, name: "Şifre Değiştir".localized()))
        settingItems.append(SettingItem(id: CHANGE_LANGUAGE, name: "Dil Değiştir".localized()))
        
        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch settingItems[indexPath.row].id {
        case EDIT_CLASS:
            pushViewController(viewController: ClassesViewController(with: .edit))
        case EDIT_STUDENT:
            pushViewController(viewController: ClassesViewController(with: .singleSelection, target: self))
        case EDIT_TEACHER:
            pushViewController(viewController: TeachersViewController(with: .edit))
        case CHANGE_PASSWORD:
            pushViewController(viewController: ChangePasswordViewController(with: .optionalChange))
            break
        case CHANGE_LANGUAGE:
            break
        default:
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
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.configure(with: settingItems[indexPath.row])
        return cell
    }
}

extension SettingsViewController: ClassSelectionDelegate {
    
    func didSelect(class: Classroom) {
        pushViewController(viewController: ClassDetailViewController(with: .edit))
    }
}
