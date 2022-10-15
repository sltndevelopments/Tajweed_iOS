//
//  StatisticElementViewModel.swift
//  Tajwid
//
//  Created by Ha Sab on 16.03.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

final class StatisticElementViewModel {
    var titleText: String
    var totalScore: Int
    var currentScore: Int
    var iconImage: UIImage?
    
    init(
   		titleText: String,
   		totalScore: Int,
        currentScore: Int,
   		iconImage: UIImage?
    ) {
        self.titleText = titleText
        self.totalScore = totalScore
        self.currentScore = currentScore
        self.iconImage = iconImage
    }
}
