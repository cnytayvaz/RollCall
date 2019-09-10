//
//  Util.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 10.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static func createNavigationcontroller(viewController: UIViewController) -> UINavigationController {
        let vc = UINavigationController(rootViewController: viewController)
        return vc
    }
    
}
