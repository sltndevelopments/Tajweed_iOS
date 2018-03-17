//
//  Created by Tagir Nafikov on 08/12/2017.
//

import UIKit


extension UIView {
    
    static var defaultIdentifier: String {
        return String(describing: self)
    }

    static func loadFromXib<T: UIView>(type: T.Type) -> T? {
        let xibName = String(describing: T.self)
        
        guard let topLevelObjects = Bundle(for: T.self).loadNibNamed(xibName, owner: nil, options: nil)
            else {
            return nil
        }
        
        let objects = topLevelObjects.flatMap { $0 as? T }
        return objects.first
    }
}
