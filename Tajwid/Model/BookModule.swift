//
//  Created by Tagir Nafikov on 17/03/2018.
//

import Foundation


final class BookModule: Decodable {
    
    // MARK: - Public properties
    
    enum ModuleType: String, Codable {
        case letters = "letters"
        case pronunciation = "pronunciationRules"
        case reading = "readingRules"
    }
    
    var title: String
    
    var type: ModuleType
    
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
