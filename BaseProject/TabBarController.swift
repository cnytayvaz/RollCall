//
//  File.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.exampleColor
        prepareViewControllers()
        delegate = self
    }
    
    func prepareViewControllers() {
        let viewControllers: [UIViewController] = []
        // create view controller and append it into "viewControllers" array to see in tabBar
        setViewControllers(viewControllers, animated: true)
        
    }
    
    func createNavigationcontroller(viewController: UIViewController, image: UIImage, selected: UIImage) -> UINavigationController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.interactivePopGestureRecognizer?.isEnabled = true
        vc.navigationBar.isHidden = true
        vc.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selected
        return vc
    }
    
}

extension TabBarController: UITabBarControllerDelegate  {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else { return false }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}

