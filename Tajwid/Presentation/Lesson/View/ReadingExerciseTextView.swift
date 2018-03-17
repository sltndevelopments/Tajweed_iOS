//
//  Created by Tagir Nafikov on 10/03/2018.
//

import UIKit
import Globus


class ReadingExerciseTextView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let wordsSeaparator = " "
        static let spaceBetweenLines = CGFloat(99)
        static let hitEdgeInsets = UIEdgeInsets(top: -5, left: -2, bottom: -5, right: -2)
    }
    
    
    // MARK: - Public properties
    
    typealias SelectWordClosure = (Int) -> Void
    
    var didSelectWordWitnIndex: SelectWordClosure?
    
    
    // MARK: - Private properties
    
    private var rows: [String]?
    
    private var rowWords: [[String]]?
    
    private var pushableLabels = [PushableLabel]()
    
    private var availableSpace = UIScreen.main.bounds.width
    
    private var textStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.arialMT, size: 40)
        textStyle.color = .blueberry
        textStyle.minimumLineHeight = 35
        textStyle.maximumLineHeight = 35
        
        return textStyle
    }
    
    private var highlitedTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.arialMT, size: 40)
        textStyle.color = .blueberryLight
        textStyle.minimumLineHeight = 35
        textStyle.maximumLineHeight = 35
        
        return textStyle
    }

    
    // MARK: - Public methods
    
    func setText(_ text: String?, withAvailableSpace space: CGFloat? = nil) {
        if let space = space {
            availableSpace = space
        }
        
        rows = self.rows(from: text)
        rowWords = rowWords(from: rows)
        arrangeText()
    }
    
    func markWords(at indexes: [Int], asCorrect isCorrect: Bool) {
        let count = pushableLabels.count
        
        for index in indexes {
            if index >= count { continue }
            
            let pushableLabel = pushableLabels[index]
            pushableLabel.state = isCorrect ? .right : .wrong
        }
    }

    
    // MARK: - Private methods
    
    private func rows(from text: String?) -> [String]? {
        guard let text = text, !text.isEmpty else { return nil }
        
        return text.components(separatedBy: "\n")
    }
    
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
        var counter = 0
        
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
                    highlitedTextAttributes: highlitedTextStyle.textAttributes,
                    isUnderscoreHidden: false)
                pushableLabel.didPress = pushableLabelPressed(_:)
                pushableLabel.tag = counter
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
                pushableLabels.append(pushableLabel)
                
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
                
                counter += 1
            }
            
            topView = rightView
            rightView = self
            space = availableSpace
        }
    }
    
    
    // MARK: - Actions
    
    private func pushableLabelPressed(_ label: PushableLabel) {
        didSelectWordWitnIndex?(label.tag)
    }

}

