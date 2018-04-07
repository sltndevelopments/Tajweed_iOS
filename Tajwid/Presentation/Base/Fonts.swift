//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit


enum FontNames {
    static let avNext = "AvenirNext-Regular"
    static let avNextMed = "AvenirNext-Medium"
    static let geezaPro = "GeezaPro"
    static let simpleArabic = "SimplifiedArabic"
    static let pnSemibold = "ProximaNova-Semibold"
    static let pn = "ProximaNova-Regular"
}


extension UIFont {
    
    class func printAllFontNames() {
        UIFont.familyNames.forEach { familyName in
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print(fontName)
            }
        }
    }
    
}

