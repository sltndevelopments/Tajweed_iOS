//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit


enum FontNames {
    static let avNext = "AvenirNext-Regular"
    static let avNextMed = "AvenirNext-Medium"
    static let geezaPro = "GeezaPro"
    static let roboto = "Roboto-Regular"
    static let pnSemibold = "ProximaNova-Semibold"
    static let pn = "ProximaNova-Regular"
    static let pnBold = "ProximaNova-Bold"
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

