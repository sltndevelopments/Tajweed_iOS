//
//  Array+Additions.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 24/02/2019.
//  Copyright © 2019 teorius. All rights reserved.
//

import Foundation


extension Array {
    
    public func withoutDuplicates() -> [Element] {
        return NSOrderedSet(array: self).array as! [Element]
    }
    
}
