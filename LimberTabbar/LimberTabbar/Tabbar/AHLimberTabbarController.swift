//
//  AHLimberTabbarController.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/23/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

class AHLimberTabbarController : UITabBarController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let index = tabBar.items?.firstIndex(of: item) {
            
            self.selectedIndex = index
            self.selectedViewController = self.viewControllers?[index]
            
            if let selectedViewController = viewControllers?[index] {
                self.delegate?.tabBarController?(self, didSelect: selectedViewController)
            }
        }
    }
}
