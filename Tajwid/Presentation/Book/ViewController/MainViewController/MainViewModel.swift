//
//  MainViewModel.swift
//  Tajwid
//
//  Created by Ha Sab on 30.01.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

protocol MainViewModelInterface {
    var authorText: String { get }
    var logoText: String { get }
    var logoImage: UIImage? { get }
    var introTitleText: String { get }
    var introDescriptionText: String { get }
    var buttonTitleText: String { get }
    
    func getStatisticViewModels() -> [StatisticElementViewModel]
    func teacherButtonTap()
}

final class MainViewModel: MainViewModelInterface {

    var authorText = "Ильдар Аляутдинов"
    var logoText = "TAJWEED"
    var introTitleText = "Дорогой друг!"
    var introDescriptionText =
        """
        Приложение предназначено для самостоятельного обучения буквам и \
        правильному произношению арабского текста при чтении Корана, \
        но если ты хочешь обучаться с учителем то нажми кнопку:
        """
    var buttonTitleText = "С учителем"
    var logoImage = UIImage(named: "tajweed_icon")
    
    private let statisticElementIcons: [UIImage?] = [
    	UIImage(named: "letters_icon"),
        UIImage(named: "pronon_icon"),
        UIImage(named: "reading_icon"),
    ]
    
    private var book: Book!
    
    init() {
        book = obtainBook()
        indexBook()
    }
    
    func getStatisticViewModels() -> [StatisticElementViewModel] {
        var statisticViewModels: [StatisticElementViewModel] = []
        for (index, module) in book.modules.enumerated() {
            let titleText = module.title
            let totalScore = module.lessons.count
            let currentScore = module.doneLessonsCount
            let statisticViewModel = StatisticElementViewModel(
                titleText: titleText,
                totalScore: totalScore,
                currentScore: currentScore,
                iconImage: statisticElementIcons[index]
            )
            statisticViewModels.append(statisticViewModel)
        }
        return statisticViewModels
    }
    
    /**
     This method indexes the book.
     As understood from the old code, the paths and indexes of the modules, lessons are set dynamically on each open of the app. The old code does the same.
     */
    private func indexBook() {
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
    
    func teacherButtonTap() {
        print("🟣 teacherButtonTap")
    }
    
    private func obtainBook() -> Book {
        if let url = Bundle.main.url(forResource: "Book", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let book = try JSONDecoder().decode(Book.self, from: data)
                return book
            }
            catch {
                print(error)
                fatalError("Couldn't obtain a book model from the book json!")
            }
        } else {
            fatalError("Couldn't obtain a book json!")
        }
    }
    
    
}
