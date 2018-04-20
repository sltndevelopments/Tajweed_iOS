//
//  Created by Tagir Nafikov on 15/04/2018.
//

import UIKit


extension UIDevice {
    
    enum ScreenType {
        case screen3_5
        case screen4
        case screen4_7
        case screen5_5
        case screen5_8
        case other
    }
    
    var screenType: ScreenType {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight == 480 { return .screen3_5}
        else if screenHeight == 568 { return .screen4}
        else if screenHeight == 667 { return .screen4_7}
        else if screenHeight == 736 { return .screen5_5}
        else if screenHeight == 812 { return .screen5_8}
        return .other
    }
    
}
