//
//  Created by Tagir Nafikov on 10/03/2018.
//

import Foundation
import Globus


extension GLBTextStyle {
    
    static var exerciseTitleTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.mainFont(ofSize: 20)
        textStyle.minimumLineHeight = 30
        textStyle.color = .greyishBrown
        
        return textStyle
    }

}
