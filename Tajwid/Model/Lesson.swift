//
//  Lesson.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 08/02/2018.
//  Copyright © 2018 teorius. All rights reserved.
//

import Foundation


final class Lesson: Decodable {
    
    // MARK: - Public properties
    
    var title: String
    var sections: [LessonSection]
    var exerciseContainers: [ExerciseContainer]
    var exercises: [Exercise] {
        return exerciseContainers.map{ $0.exercise }
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
