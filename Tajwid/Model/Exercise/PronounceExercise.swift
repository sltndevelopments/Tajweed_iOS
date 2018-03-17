//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class PronounceExercise: Exercise {
    
    // MARK: - Public properties
    
    var rows: [String]
    
    
    // MARK: - Decodable

    private enum CodingKeys: String, CodingKey {
        case rows
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rows = try values.decode([String].self, forKey: .rows)
        
        try super.init(from: decoder)
    }

}
