//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit


extension UIScrollView {
    
    var shouldScrollVerically: Bool {
        return contentSize.height + contentInset.top + contentInset.bottom > bounds.height
    }
    
}
