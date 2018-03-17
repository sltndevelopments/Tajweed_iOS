//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


class Exercise: Decodable {
    
    // MARK: - Public properties
    
    var title: String
    
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
    }
    
}
