//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class WritingByExampleExercise: Exercise {
    
    // MARK: - Public properties
    
    var example: String
    
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case example
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        example = try values.decode(String.self, forKey: .example)        
        
        try super.init(from: decoder)
    }

}
