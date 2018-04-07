//
//  Created by Tagir Nafikov on 08/12/2017.
//

import UIKit


extension UIView {
    
    static var defaultIdentifier: String {
        return String(describing: self)
    }

    static var defaultNib: UINib {
        return UINib(nibName: defaultIdentifier, bundle: nil)
    }

    static func loadFromXib<T: UIView>(type: T.Type) -> T? {
        let xibName = String(describing: T.self)
        
        guard let topLevelObjects = Bundle(for: T.self).loadNibNamed(xibName, owner: nil, options: nil)
            else {
            return nil
        }
        
        let objects = topLevelObjects.compactMap { $0 as? T }
        return objects.first
    }
    
    func makeImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }

}
