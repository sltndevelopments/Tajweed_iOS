//
//  Created by Tagir Nafikov on 21/02/2018.
//

import Foundation


struct ExerciseContainer: Decodable {
    
    // MARK: - Nested types
    
    enum ExerciseType: String {
        case test
        case pronounce
        case writingByExample
        case writingByTranscription
        case reading
    }
    
    
    // MARK: - Public properties
    
    var exerciseType: ExerciseType
    var exercise: Exercise
    
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case exerciseType = "type"
        case exercise = "content"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeString = try values.decode(String.self, forKey: .exerciseType)
        exerciseType = ExerciseType(rawValue: typeString)!
        
        switch exerciseType {
        case .test:
            exercise = try values.decode(TestExercise.self, forKey: .exercise)
            let testExercise = exercise as! TestExercise
        case .pronounce:
            exercise = try values.decode(PronounceExercise.self, forKey: .exercise)
        case .writingByExample:
            exercise = try values.decode(WritingByExampleExercise.self, forKey: .exercise)
        case .writingByTranscription:
            exercise = try values.decode(
                WritingByTranscriptionExercise.self,
                forKey: .exercise)
        case .reading:
            exercise = try values.decode(ReadingExercise.self, forKey: .exercise)
        }

    }
    
}
