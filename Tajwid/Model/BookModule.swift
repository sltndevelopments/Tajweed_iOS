//
//  Created by Tagir Nafikov on 17/03/2018.
//

import Foundation


final class BookModule: Decodable {
    
    // MARK: - Public properties
    
    var title: String
    
    var lessons: [Lesson]
    
    var path: String?
    
    var index: Int?
    
    var doneLessonsCount: Int {
        var count = 0
        for lesson in lessons {
            if AppProgressManager.isItemDone(key: lesson.path) { count += 1 }
        }
        return count
    }
 
}
