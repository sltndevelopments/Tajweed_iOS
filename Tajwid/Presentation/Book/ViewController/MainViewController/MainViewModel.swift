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
