//
//  Created by Tagir Nafikov on 10/03/2018.
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
