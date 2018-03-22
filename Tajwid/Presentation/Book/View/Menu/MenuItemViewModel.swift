//
//  Created by Tagir Nafikov on 18/03/2018.
//

import Foundation


struct MenuItemViewModel {
    
    var title: String
    
    var subtitle: String?
    
    var isSeparatorHidden: Bool
    
    var isSubtitleHidden: Bool {
        return subtitle?.isEmpty != false
    }
    
}
