//
//  UIScrollView+Additions.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 25/02/2018.
//  Copyright © 2018 teorius. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    var shouldScrollVerically: Bool {
        return contentSize.height + contentInset.top + contentInset.bottom > bounds.height
    }
    
}
