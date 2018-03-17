//
//  Created by Tagir Nafikov on 11/02/2018.
//

import Foundation
import Globus


extension GLBTextStyle {
    
    var textAttributes: [NSAttributedStringKey: Any]? {
        guard let attributes = attributes else { return nil }
        
        let attributedStringKeysDict = attributes.lazy.map {
            (NSAttributedStringKey($0.key), $0.value)
        }
        let textAttributes = Dictionary(uniqueKeysWithValues: attributedStringKeysDict)
        
        return textAttributes
    }
    
}

