//
//  MainViewModel.swift
//  Tajwid
//
//  Created by Ha Sab on 30.01.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewModelInterface {
    var authorText: String { get }
    var logoText: String { get }
    var logoImage: UIImage? { get }
    var introTitleText: String { get }
    var introDesvriptionText: String { get }
    var buttonTitleText: String { get }
}

final class MainViewModel: MainViewModelInterface {

    var authorText = "Ильдар Аляутдинов"
    var logoText = "TAJWEED"
    var introTitleText = "Дорогой друг!"
    var introDesvriptionText =
        """
        Приложение предназначено для самостоятельного обучения буквам и \
        правильному произношению арабского текста при чтении Корана, \
        но если ты хочешь обучаться с учителем то нажми кнопку:
        """
    var buttonTitleText = "С учителем"
    var logoImage = UIImage(named: "tajweed_icon")
    
}
