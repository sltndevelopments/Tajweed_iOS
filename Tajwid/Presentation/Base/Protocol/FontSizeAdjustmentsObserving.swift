//
//  Created by Tagir Nafikov on 07/04/2018.
//

import UIKit


@objc protocol FontSizeAdjustmentsObserving {
    
    func beginObservingFontSizeAdjustments()
    
    func endObservingFontSizeAdjustments()
    
    func adjustFontSize(to value: CGFloat)
    
}
