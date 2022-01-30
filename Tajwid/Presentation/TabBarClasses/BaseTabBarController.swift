//
//  BaseTabBarController.swift
//  Tajwid
//
//  Created by Ildar Zalyalov on 2022-01-29.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    
    // MARK: - Overrided properties -
    
    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return selectedViewController?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAppearance()
    }
    
    private func configureAppearance() {
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.tabItemGreen
        tabBar.unselectedItemTintColor = UIColor.tabItemHalfGreen
        tabBar.tintAdjustmentMode = .normal
        
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.backgroundColor = .white
            
            let itemTitleFont: UIFont = .systemFont(ofSize: 10)
            
            appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemGray,
                .font: itemTitleFont
            ]
//            appearance.stackedLayoutAppearance.selected.iconColor =
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.black
                ,
                .font: itemTitleFont
            ]
            
            tabBar.standardAppearance = appearance
        }
       
#if swift(>=5.5)
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
#endif
    }
}
