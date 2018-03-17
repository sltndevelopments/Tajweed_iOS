//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class LessonSection: Decodable {
    
    var title: String
    var arabicTitle: String?
    var cards: [LessonCard]
    
}
