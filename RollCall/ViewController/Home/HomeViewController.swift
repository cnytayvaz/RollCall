//
//  HomeViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 10.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let ROW_ITEM_COUNT = 4
    let ITEM_SPACE = 3
    
    var menuItems: [(pageId: Int, description: String, iconName: String, color: UIColor)] = []
    let GROUP_MESSAGE = 0
    let PERSONAL_MESSAGE = 1
    let ROLL_CALL = 2
    let SETTINGS = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userType = UserManager.getUserType()
        
        switch userType {
        case .admin:
            menuItems = [(PERSONAL_MESSAGE, "Bireysel Mesaj".localized(), "personal-message", UIColor.personalMessage),
                       (GROUP_MESSAGE, "Sınıf Mesajı".localized(), "group-message", UIColor.classMessage),
                       (ROLL_CALL, "Yoklama".localized(), "roll-call", UIColor.rollCall),
                       (SETTINGS, "Ayarlar".localized(), "settings", UIColor.settings)]
            
        case .teacher:
            break
        case .parent:
            break
        }
        
        collectionView.register(MenuCollectionViewCell.nib, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func isBackActionEnabled() -> Bool {
        return false
    }
    
    override func isNavigationBarHidden() -> Bool {
        return true
    }
    
    override func setText() {
        titleLabel.text = "Merhaba,".localized()
        usernameLabel.text = "Cüneyt AYVAZ".localized()
    }
    
    func findArrayIndex(_ indexPath: IndexPath) -> Int {
        return (indexPath.section * ROW_ITEM_COUNT) + indexPath.row
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch menuItems[indexPath.row].pageId {
        case PERSONAL_MESSAGE:
            pushViewController(viewController: ClassesViewController())
        case GROUP_MESSAGE:
            pushViewController(viewController: MessagesViewController())
        case ROLL_CALL:
            pushViewController(viewController: ClassesViewController())
        case SETTINGS:
            pushViewController(viewController: SettingsViewController())
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = findArrayIndex(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as! MenuCollectionViewCell
        cell.configure(with: menuItems[index])
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
