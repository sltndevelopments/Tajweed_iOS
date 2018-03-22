//
//  Created by Tagir Nafikov on 01/12/2017.
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
