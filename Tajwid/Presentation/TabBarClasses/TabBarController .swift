//
//  TabBarController .swift
//  Tajwid
//
//  Created by Ildar Zalyalov on 2022-01-29.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

/// TabBarController Configurator
protocol MainTabBarConfigurator: AnyObject {
    
    /// Configure TabBarController with controllers
    /// - Parameters:
    ///   - controllers: controllers for UITabBarController
    func configuredTabBar(with controllers: [UIViewController]) -> UITabBarController
}

class MainTabBarController: BaseTabBarController, MainTabBarConfigurator {
    
    
    @discardableResult
    func configuredTabBar(with controllers: [UIViewController]) -> UITabBarController {
        self.viewControllers = controllers
        return self
    }
    
}
