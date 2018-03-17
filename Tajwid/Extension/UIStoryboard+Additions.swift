//
//  UIStoryboard+Additions.swift
//  DSA
//
//  Created by Tagir Nafikov on 01/12/2017.
//  Copyright © 2017 AK BARS DIGITAL TECHNOLOGIES OOO. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func viewController<ViewControllerType: UIViewController>(
        ofType: ViewControllerType.Type,
        fromStoryboard storyboardName: String) -> ViewControllerType {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: ViewControllerType.defaultIdentifier) as? ViewControllerType
            else {
                fatalError("Found view controller's type doesn't match a given type")
        }
        
        return viewController
    }
    
}
