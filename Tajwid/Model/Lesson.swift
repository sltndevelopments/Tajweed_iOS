//
//  Created by Tagir Nafikov on 08/02/2018.
//

import Foundation


final class Lesson: Decodable, CustomStringConvertible {
    
    // MARK: - Public properties
    
    var title: String
    
    var sections: [LessonSection]
    
    var exerciseContainers: [ExerciseContainer]
    
    var exercises: [Exercise] {
        return exerciseContainers.map{ $0.exercise }
    }
    
    lazy var cards: [LessonCard] = {
        var cards = [LessonCard]()
        for section in sections {
            cards.append(contentsOf: section.cards)
        }
        return cards
    }()
    
    var cardsCount: Int {
        var count = 0
        sections.forEach { count += $0.cards.count }
        return count
    }
    
    var path: String?
    
    var index: Int?

    
    // MARK: - CustomStringConvertible
    
    var description: String {
        let exercisesCount = exercises.count
        let exercisesPluralString = "exercise".localizedPlural(for: exercisesCount).uppercased()
        let exercisesString = exercises.isEmpty ? "БЕЗ УПРАЖНЕНИЙ" : "\(exercisesCount) \(exercisesPluralString)"
        let cardsCount = self.cardsCount
        let cardsPluralString = "card".localizedPlural(for: cardsCount).uppercased()
        
        return "\(cardsCount) \(cardsPluralString), \(exercisesString)"
    }

    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case title
        case sections
        case exerciseContainers = "exercises"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        sections = try values.decode([LessonSection].self, forKey: .sections)
        
        exerciseContainers = try values.decode(
            [ExerciseContainer].self,
            forKey: .exerciseContainers)
    }

}
