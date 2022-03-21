//
//  TabBarItemsBuilder.swift
//  Tajwid
//
//  Created by Ildar Zalyalov on 2022-01-30.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

/// Type that used for creating UITabBarItem
/// Contains all possible item types
public enum TabBarItemType {
    
    case main
    case letters
    case pronunciationRules
    case readingRules
    case settings
    
    /// UITabBarItem title
    var title: String? {
        switch self {
        case .main:
            return "Главная"
        case .letters:
            return "Буквы"
        case .pronunciationRules:
            return "Произношение"
        case .readingRules:
            return "Чтение"
        case .settings:
            return "Настройки"
        }
    }
    
    /// UITabBarItem Image
    var image: UIImage? {
        switch self {
        case .main:
            return UIImage(named: "main_icon")
        case .letters:
            return UIImage(named: "letters_icon")
        case .pronunciationRules:
            return UIImage(named: "pronon_icon")
        case .readingRules:
            return UIImage(named: "reading_icon")
        case .settings:
            return UIImage(named: "settings_icon")
        }
    }
    
    /// UITabBarItem selected Image
    var selectedImage: UIImage? {
        switch self {
        default:
            return nil
        }
    }
}

/// Builder to get UITabBarItem
protocol TabBarItemsBuildable: AnyObject {
    
    /// Get UITabBarItem by type
    /// - Parameter type: type of TabBarItem
    func getTabBarItem(by type: TabBarItemType) -> UITabBarItem
}

class TabBarItemsBuilder: TabBarItemsBuildable {
    
    func getTabBarItem(by type: TabBarItemType) -> UITabBarItem {
        let targetImageSize = CGSize(width: 25, height: 25)
        let scaledImage = type.image?.scalePreservingAspectRatio(targetSize: targetImageSize)
        let tabBarItem = UITabBarItem(title: type.title, image: scaledImage, selectedImage: type.selectedImage)
        
        return tabBarItem
    }
}

private extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
