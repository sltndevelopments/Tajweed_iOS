//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class ReadingExercise: Exercise {
    
    // MARK: - Public properties
    
    var text: String
    var correctWords: [String]
    
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case text
        case correctWords
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        correctWords = try values.decode([String].self, forKey: .correctWords)
        
        try super.init(from: decoder)
    }

}
