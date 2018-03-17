//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus


class PronounceExerciseTextView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let wordsSeaparator = " ، "
        static let spaceBetweenLines = CGFloat(70)
        static let hitEdgeInsets = UIEdgeInsets(top: -5, left: -10, bottom: -5, right: -10)
    }
    
    
    // MARK: - Private properties
    
    private var rows: [String]?
    
    private var rowWords: [[String]]?
    
    private var availableSpace = UIScreen.main.bounds.width
    
    private var textStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.arialMT, size: 40)
        textStyle.color = .blueberry
        
        return textStyle
    }
    
    private var highlitedTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.arialMT, size: 40)
        textStyle.color = .blueberryLight
        
        return textStyle
    }
    
    
    // MARK: - Public methods
    
    func setRow(_ rows: [String], withAvailableSpace space: CGFloat? = nil) {
        if let space = space {
            availableSpace = space
        }
        
        rowWords = rowWords(from: rows)
        arrangeText()
    }
    
    
    // MARK: - Private methods
    
    private func rowWords(from rows: [String]?) -> [[String]]? {
        guard let rows = rows, !rows.isEmpty else { return nil }
        
        return rows.map{ $0.components(separatedBy: Constants.wordsSeaparator) }
    }
    
    private func arrangeText() {
        subviews.forEach { $0.removeFromSuperview() }
        
        guard let rowWords = rowWords else { return }
        
        var rightView: UIView = self
        var topView: UIView = self
        var space = availableSpace
        
        for (rowIndex, row) in rowWords.enumerated() {
            for (wordIndex, word) in row.enumerated() {
                /// последнее ли слово
                let isLastInRow = wordIndex == row.count - 1
                let isLastInText = isLastInRow && rowIndex == rowWords.count - 1
                
                /// вычисляем размер текста, который необходимо добавить
                var textToAppend = word
                if !isLastInRow {
                    textToAppend += Constants.wordsSeaparator
                }
                let attributedText = NSAttributedString(
                    string: textToAppend,
                    attributes: textStyle.textAttributes)
                let size = CGSize(width: CGFloat(1000), height: .greatestFiniteMagnitude)
                let width = attributedText.boundingRect(
                    with: size,
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil)
                    .size
                    .width
                
                /// если не осталось достаточно места в строке, переносим
                if space >= width {
                    space -= width
                } else {
                    topView = rightView
                    rightView = self
                    space = availableSpace
                }
                
                let pushableLabel = PushableLabel(
                    text: word,
                    normalTextAttributes: textStyle.textAttributes,
                    highlitedTextAttributes: highlitedTextStyle.textAttributes)
                pushableLabel.didPress = pushableLabelPressed(_:)
                addSubview(pushableLabel)
                pushableLabel.snp.makeConstraints { maker in
                    if rightView == self {
                        maker.right.equalToSuperview()
                    } else {
                        maker.right.equalTo(rightView.snp.left)
                    }
                    if topView == self {
                        maker.top.equalToSuperview()
                    } else {
                        maker
                            .firstBaseline
                            .equalTo(topView.snp.firstBaseline)
                            .offset(Constants.spaceBetweenLines)
                    }
                    
                    if isLastInText {
                        maker.bottom.equalToSuperview()
                    }
                }
                rightView = pushableLabel
                
                if !isLastInRow {
                    let label = UILabel()
                    label.attributedText = NSAttributedString(
                        string: Constants.wordsSeaparator,
                        attributes: textStyle.textAttributes)
                    addSubview(label)
                    label.snp.makeConstraints { maker in
                        maker.right.equalTo(pushableLabel.snp.left)
                        
                        maker.firstBaseline.equalTo(pushableLabel.snp.firstBaseline)
                    }
                    
                    rightView = label
                }
            }
            
            topView = rightView
            rightView = self
            space = availableSpace
        }
    }
    
    
    // MARK: - Actions
    
    private func pushableLabelPressed(_ label: PushableLabel) {
        print(label.text ?? "No text")
    }
    
}
