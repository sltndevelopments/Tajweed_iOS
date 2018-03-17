//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class LessonCard: Decodable {
    
    var title: String?
    var contentItems: [LessonCardContentItem]
    
}
