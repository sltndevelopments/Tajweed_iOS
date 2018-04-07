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
 
}
