//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class TestExercise: Exercise {
    
    // MARK: - Public properties
    
    var text: String
    var variants: [String]
    var correctVariant: String
    
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case text
        case variants
        case correctVariant
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        variants = try values.decode([String].self, forKey: .variants)
        correctVariant = try values.decode(String.self, forKey: .correctVariant)

        try super.init(from: decoder)
    }

}
