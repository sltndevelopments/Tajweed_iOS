//
//  TabBarControllersBuilder.swift
//  Tajwid
//
//  Created by Ildar Zalyalov on 2022-01-29.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControllersBuildable: AnyObject {
    
    func buildTabBarControllers(with bookService: BookService, tabBarItemsBuilder: TabBarItemsBuildable, completion: @escaping ([UIViewController]) -> Void)
}

class TabBarControllersBuilder: TabBarControllersBuildable {
    
    func buildTabBarControllers(with bookService: BookService, tabBarItemsBuilder: TabBarItemsBuildable, completion: @escaping ([UIViewController]) -> Void) {
        
        bookService.obtainBook { [weak self] result in
            
            switch result {
            case .success(let book):
                
                let controllers = self?.configureTabBarControllers(with: book, tabBarItemsBuilder: tabBarItemsBuilder) ?? []
                completion(controllers)
            case .failure(let error):
                print(error)
                
                completion([])
            }
        }
    }
    
    private func configureTabBarControllers(with book: Book, tabBarItemsBuilder: TabBarItemsBuildable) -> [UIViewController] {
        
        var controllers = [UIViewController]()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabController = mainStoryboard.instantiateViewController(withIdentifier: "MainScreenViewController")
        mainTabController.tabBarItem = tabBarItemsBuilder.getTabBarItem(by: .main)
    
        controllers.append(mainTabController)
        
        for module in book.modules {
            
            guard let bookTabController = mainStoryboard.instantiateViewController(withIdentifier: "BookModuleViewController") as? BookModuleViewController else { continue }
            
            switch module.type {
            case .reading:
                bookTabController.tabBarItem = tabBarItemsBuilder.getTabBarItem(by: .readingRules)
            case .pronunciation:
                bookTabController.tabBarItem = tabBarItemsBuilder.getTabBarItem(by: .pronunciationRules)
            case .letters:
                bookTabController.tabBarItem = tabBarItemsBuilder.getTabBarItem(by: .letters)
            }
            
            let navigationController = UINavigationController(rootViewController: bookTabController)
            bookTabController.module = module
            
            controllers.append(navigationController)
        }
        
        let settingsTabController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController")
        let settingsNavigationController = UINavigationController(rootViewController: settingsTabController)
        settingsNavigationController.tabBarItem = tabBarItemsBuilder.getTabBarItem(by: .settings)
        
        controllers.append(settingsNavigationController)
        
        return controllers
    }
}
