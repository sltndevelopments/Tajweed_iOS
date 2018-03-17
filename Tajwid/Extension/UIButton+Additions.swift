//
//  Created by Tagir Nafikov on 07/02/2018.
//

import UIKit


extension UIButton {
    
    // MARK: - Constants
    
    private struct AssociatedKeys {
        static var hitEdgeInsetsAssociatedKey = "hitEdgeInsetsAssociatedKey"
    }

    
    // MARK: - Public properties
    
    var hitEdgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.hitEdgeInsetsAssociatedKey) as? NSValue {
                return value.uiEdgeInsetsValue
            }
            let hitEdgeInsets = UIEdgeInsets()
            let value = NSValue(uiEdgeInsets: hitEdgeInsets)
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.hitEdgeInsetsAssociatedKey,
                value as NSValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return hitEdgeInsets
        }
        set {
            let value = NSValue(uiEdgeInsets: newValue)

            objc_setAssociatedObject(
                self,
                &AssociatedKeys.hitEdgeInsetsAssociatedKey,
                value as NSValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    // MARK: - Override
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hitEdgeInsets == .zero || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }
        
        let hitFrame = UIEdgeInsetsInsetRect(bounds, hitEdgeInsets)
        
        return hitFrame.contains(point)
    }
    
}
