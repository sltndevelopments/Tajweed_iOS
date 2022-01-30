//
//  Created by Tagir Nafikov on 11/02/2018.
//

import UIKit
import SwiftHEXColors


extension UIColor {
    
    // MARK: - Private properties
    
    private static let defaultColor = UIColor.black
    
    
    // MARK: - Public properties
    
    static var whiteOne: UIColor {
        let color = UIColor(hexString: "#f9f9f9") ?? defaultColor
        return color
    }

    static var whiteTwo: UIColor {
        let color = UIColor(hexString: "#d8d8d8") ?? defaultColor
        return color
    }

    static var whiteThree: UIColor {
        let color = UIColor(hexString: "#f7f7f7") ?? defaultColor
        return color
    }

    static var warmGrey: UIColor {
        let color = UIColor(hexString: "#979797") ?? defaultColor
        return color
    }
    
    static var blueberry: UIColor {
        let color = UIColor(hexString: "#4d2d8c") ?? defaultColor
        return color
    }
    
    static var blueberryLight: UIColor {
        let color = UIColor(hexString: "#9782c2") ?? defaultColor
        return color
    }

    static var blackOne: UIColor {
        let color = UIColor(hexString: "#333333") ?? defaultColor
        return color
    }
    
    static var deepRose: UIColor {
        let color = UIColor(hexString: "#c34d5b") ?? defaultColor
        return color
    }
    
    static var shamrockGreen: UIColor {
        let color = UIColor(hexString: "#00c853") ?? defaultColor
        return color
    }
    
    static var greyishBrown: UIColor {
        let color = UIColor(hexString: "#4a4a4a") ?? defaultColor
        return color
    }

    static var greyishBrownTwo: UIColor {
        let color = UIColor(hexString: "#434343") ?? defaultColor
        return color
    }

    static var warmGrey30: UIColor {
        let color = UIColor(hexString: "#979797", alpha: 0.3) ?? defaultColor
        return color
    }

    static var white82: UIColor {
        let color = UIColor(hexString: "#f8f8f8", alpha: 0.82) ?? defaultColor
        return color
    }

    static var redOne: UIColor {
        let color = UIColor(hexString: "#e14949") ?? defaultColor
        return color
    }

    static var redTwo: UIColor {
        let color = UIColor(hexString: "#E92530") ?? defaultColor
        return color
    }

    static var blueOne: UIColor {
        let color = UIColor(hexString: "#1FADE3") ?? defaultColor
        return color
    }

    static var tabItemHalfGreen: UIColor {
        let color = UIColor(hexString: "#B7DA00")?.withAlphaComponent(0.5) ?? defaultColor
        return color
    }
    
    static var tabItemGreen: UIColor {
        let color = UIColor(hexString: "#B7DA00") ?? defaultColor
        return color
    }
}

