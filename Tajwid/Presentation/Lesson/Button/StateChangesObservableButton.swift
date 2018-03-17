//
//  StateChangesObservableButton.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 10/03/2018.
//  Copyright © 2018 teorius. All rights reserved.
//

import UIKit


class StateChangesObservableButton: UIButton {

    // MARK: - Public properties
    
    typealias StateChangeClosure = (Bool) -> Void
    
    var highlitedStateChanged: StateChangeClosure?
    
    
    // MARK: - Override
    
    override var isHighlighted: Bool {
        willSet {
            if isHighlighted != newValue {
                highlitedStateChanged?(newValue)
            }
        }
    }

}
