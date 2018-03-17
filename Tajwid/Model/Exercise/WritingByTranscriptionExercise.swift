//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class WritingByTranscriptionExercise: Exercise {
    
    // MARK: - Public properties
    
    var transcription: String
    var correctWriting: String
    
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case transcription
        case correctWriting
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transcription = try values.decode(String.self, forKey: .transcription)
        correctWriting = try values.decode(String.self, forKey: .correctWriting)
        
        try super.init(from: decoder)
    }

}
