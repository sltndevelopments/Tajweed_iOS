//
//  Created by Tagir Nafikov on 07/04/2018.
//

import UIKit


enum FontName: String {
    case avenirNext
    case georgia
    
    var regularFontName: String {
        switch self {
        case .avenirNext:
            return "AvenirNext-Regular"
        case .georgia:
            return "Georgia"
        }
    }
    
    var mediumFontName: String {
        switch self {
        case .avenirNext:
            return "AvenirNext-Medium"
        case .georgia:
            return "Georgia-Bold"
        }
    }
    
    var boldFontName: String {
        switch self {
        case .avenirNext:
            return "AvenirNext-Bold"
        case .georgia:
            return "Georgia-Bold"
        }
    }

    var allNames: [String] {
        return [regularFontName, mediumFontName, boldFontName]
    }
    
}


final class FontCreator  {
    
    // MARK: - Class public properties
    
    static var fontSizeAddition: CGFloat {
        get {
            return SettingsManager.fontSizeAddition
        }
        set {
            if newValue == fontSizeAddition { return }
            
            let difference = newValue - fontSizeAddition
            
            for object in observers.objectEnumerator() {
                if let observer = object as? FontAdjustmentsObserving {
                    observer.adjustFontSize(to: difference)
                }
            }
            
            SettingsManager.fontSizeAddition = newValue
            
            for object in observers.objectEnumerator() {
                if let observer = object as? FontAdjustmentsObserving {
                    observer.fontSettingsChanged()
                }
            }

        }
    }
    
    static var mainFontName: FontName {
        get {
            if let fontNameString = SettingsManager.mainFontName,
                let fontName = FontName(rawValue: fontNameString) {
                return fontName
            }
            
            return FontName.avenirNext
        }
        set {
            if mainFontName == newValue { return }
            
            let oldNames = mainFontName.allNames
            let newNames = newValue.allNames
            for (index, oldName) in oldNames.enumerated() {
                let newName = newNames[index]
                
                for object in observers.objectEnumerator() {
                    if let observer = object as? FontAdjustmentsObserving {
                        observer.changeFont(withName: oldName, to: newName)
                    }
                }
            }
            
            SettingsManager.mainFontName = newValue.rawValue
            
            for object in observers.objectEnumerator() {
                if let observer = object as? FontAdjustmentsObserving {
                    observer.fontSettingsChanged()
                }
            }
        }
    }
    
    
    // MARK: - Class private properties
    
    private static var observers = NSHashTable<FontAdjustmentsObserving>.weakObjects()
    
    
    // MARK: - Public methods
    
    static func fontWithName(_ name: String, size: CGFloat) -> UIFont? {
        return UIFont(name: name, size: size + fontSizeAddition)
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont? {
        return fontWithName(mainFontName.regularFontName, size: size)
    }
    
    static func mediumMainFont(ofSize size: CGFloat) -> UIFont? {
        return fontWithName(mainFontName.mediumFontName, size: size)
    }
    
    static func boldMainFont(ofSize size: CGFloat) -> UIFont? {
        return fontWithName(mainFontName.boldFontName, size: size)
    }

    static func addFontSizeAdjustmentsObserver(_ observer: FontAdjustmentsObserving) {
        observers.add(observer)
    }
    
    static func removeFontSizeAdjustmentsObserver(_ observer: FontAdjustmentsObserving) {
        observers.remove(observer)
    }

}
