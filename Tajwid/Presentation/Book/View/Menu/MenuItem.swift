//
//  Created by Tagir Nafikov on 18/03/2018.
//

import Foundation


enum MenuItemType {
    case module(BookModule)
    case settings
}


struct MenuItem {
    
    var type: MenuItemType
    
    var title: String
    
    var subtitle: String?

}
