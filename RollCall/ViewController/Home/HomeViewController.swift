//
//  HomeViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 10.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit
import CircleMenu

class HomeViewController: BaseViewController {

    var buttons: [(icon: String, color: UIColor, pageId: Int)] = []
    let GROUP_MESSAGE = 0
    let PERSONAL_MESSAGE = 1
    let ROLL_CALL = 2
    let SETTINGS = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userType = UserManager.getUserType()
        
        switch userType {
        case .admin:
            buttons = [("personal-message", UIColor.rollCallButton, PERSONAL_MESSAGE),
                       ("group-message", UIColor.messageButton, GROUP_MESSAGE),
                       ("roll-call", UIColor.groupMessageButton, ROLL_CALL),
                       ("settings", UIColor.messageButton, SETTINGS)]
        case .teacher:
            break
        case .parent:
            break
        }

        // Do any additional setup after loading the view.
        let button = CircleMenu(
            frame: CGRect(x: view.frame.width / 2 - 25, y: view.frame.height / 2 - 25, width: 50, height: 50),
            normalIcon: "logo",
            selectedIcon: nil,
            buttonsCount: buttons.count,
            duration: 1,
            distance: 120)
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        view.addSubview(button)
    }
    
    override func isBackActionEnabled() -> Bool {
        return false
    }
    
    override func isNavigationBarHidden() -> Bool {
        return true
    }

}

extension HomeViewController: CircleMenuDelegate {
    
    // configure buttons
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = buttons[atIndex].color
        button.setImage(UIImage(named: buttons[atIndex].icon), for: .normal)
    }
    
    // call before animation
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        
        let pageId = buttons[atIndex].pageId
        switch pageId {
        case PERSONAL_MESSAGE:
            pushViewController(viewController: MessagesViewController())
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
    
    // call after animation
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
    }
    
    // call upon cancel of the menu - fires immediately on button press
    func menuCollapsed(_ circleMenu: CircleMenu) {
        
    }
    
    // call upon opening of the menu - fires immediately on button press
    func menuOpened(_ circleMenu: CircleMenu) {
        
    }
    
}
