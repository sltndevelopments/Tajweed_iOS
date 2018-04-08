//
//  Created by Tagir Nafikov on 07/04/2018.
//

import UIKit


@objc protocol FontAdjustmentsObserving {
    
    func beginObservingFontAdjustments()
    
    func endObservingFontAdjustments()
    
    func adjustFontSize(to value: CGFloat)
    
    func changeFont(withName name: String, to anotherFontName: String)
    
}
