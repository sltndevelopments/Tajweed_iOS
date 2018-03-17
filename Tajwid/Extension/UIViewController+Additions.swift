//
//  UIViewController+Additions.swift
//  DSA
//
//  Created by Tagir Nafikov on 01/12/2017.
//  Copyright © 2017 AK BARS DIGITAL TECHNOLOGIES OOO. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var defaultIdentifier: String {
        return String(describing: self)
    }
    
    var defaultIdentifier: String {
        return String(describing: type(of: self))
    }
    
}
