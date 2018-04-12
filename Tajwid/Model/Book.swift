//
//  Created by Tagir Nafikov on 17/03/2018.
//

import Foundation


final class Book: Decodable {
    
    var modules: [BookModule]
    
    lazy var lessons: [Lesson] = {
        var lessons = [Lesson]()
        for module in modules {
            lessons.append(contentsOf: module.lessons)
        }
        return lessons
    }()

}
