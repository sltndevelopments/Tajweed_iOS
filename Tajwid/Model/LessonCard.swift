//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class LessonCard: Decodable {
    
    var title: String?
    
    var contentItems: [LessonCardContentItem] = []
    
    var path: String?
    
    var index: Int?
    
    var soundURL: URL?

    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case title
        case contentItems
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decode(String.self, forKey: .title)
        contentItems = try values.decode([LessonCardContentItem].self, forKey: .contentItems)
    }

}
