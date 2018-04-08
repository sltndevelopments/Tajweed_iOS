//
//  Created by Tagir Nafikov on 07/04/2018.
//

import UIKit


final class FontCreator  {
    
    // MARK: - Class public properties
    
    static var fontSizeAddition: CGFloat = 0 {
        willSet {
            let difference = newValue - fontSizeAddition
            
            if difference != 0 {
                for object in observers.objectEnumerator() {
                    if let observer = object as? FontSizeAdjustmentsObserving {
                        observer.adjustFontSize(to: difference)
                    }
                }
            }
        }
    }
    
    
    // MARK: - Class private properties
    
    private static var observers = NSHashTable<FontSizeAdjustmentsObserving>.weakObjects()
    
    
    // MARK: - Public methods
    
    static func fontWithName(_ name: String, size: CGFloat) -> UIFont? {
        return UIFont(name: name, size: size + fontSizeAddition)
    }
    
    static func addFontSizeAdjustmentsObserver(_ observer: FontSizeAdjustmentsObserving) {
        observers.add(observer)
    }
    
    static func removeFontSizeAdjustmentsObserver(_ observer: FontSizeAdjustmentsObserving) {
        observers.remove(observer)
    }

}
