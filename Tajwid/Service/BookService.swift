//
//  BookService.swift
//  Tajwid
//
//  Created by Ildar Zalyalov on 2022-01-30.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation

protocol BookService {
    
    /// Obtain book from json file 
    /// - Returns: Book model
    func obtainBook(completion: @escaping (Result<Book, Error>) -> Void)
}

class BookServiceImplementation: BookService {
    
    func obtainBook(completion: @escaping (Result<Book, Error>) -> Void) {
         
        guard let url = Bundle.main.url(forResource: "Book", withExtension: "json") else {
            fatalError("Couldn't obtain a book json!")
        }
        
        let queue = DispatchQueue(label: "read book", qos: .userInitiated)
        
        queue.async { [weak self] in
            
            var result: Result<Book, Error>
            
            guard let self = self else {
                fatalError("Self is deallocated")
            }
            
            do {
                let data = try Data(contentsOf: url)
                let book = try JSONDecoder().decode(Book.self, from: data)
                self.indexBook(book)
                
                result = .success(book)
            }
            catch {
                result = .failure(error)
                fatalError("Couldn't obtain a book model from the book json!")
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func indexBook(_ book: Book) {
        for (index, module) in book.modules.enumerated() {
            module.index = index
            module.path = String(index + 1)
            
            for (index, lesson) in module.lessons.enumerated() {
                lesson.index = index
                lesson.path = "\(module.path!)_\(index + 1)"
                
                var cardsCount = 0
                for section in lesson.sections {
                    for (index, card) in section.cards.enumerated() {
                        let index = index + cardsCount
                        card.index = index
                        card.path = "\(lesson.path!)_\(index + 1)"
                    }
                    
                    cardsCount += section.cards.count
                }
                
                for (index, exercise) in lesson.exercises.enumerated() {
                    let index = index + cardsCount
                    exercise.index = index
                    exercise.path = "\(lesson.path!)_\(index + 1)"
                    
                    if let readingExercise = exercise as? ReadingExercise {
                        readingExercise.correctWords = readingExercise.correctWords.withoutDuplicates()
                    }
                }
            }
        }
    }
}
