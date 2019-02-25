//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus


protocol PronounceExerciseTextViewDelegate: class {
    
    func textView(_ textView: PronounceExerciseTextView, didSelectWord word: String?, at index: Int)
    
}


class PronounceExerciseTextView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let spaceBetweenLines = CGFloat(86)
        static let hitEdgeInsets = UIEdgeInsets(top: -5, left: -10, bottom: -5, right: -10)
    }
    
    
    // MARK: - Public properties
    
    weak var delegate: PronounceExerciseTextViewDelegate?
    
    
    // MARK: - Private properties
    
    private var rows: [String]?
    
    private var rowWords: [[String]]?
    
    private var isCommaSeparated = false
    
    private var wordsSeparator: String {
        return isCommaSeparated ? " ، " : " "
    }
    
    private var availableSpace = UIScreen.main.bounds.width
    
    private var textStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.arabic, size: 40)
        textStyle.color = .blueberry
        if !isCommaSeparated {
            textStyle.alignment = .right
        }
        
        return textStyle
    }
    
    private var highlitedTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.arabic, size: 40)
        textStyle.color = .blueberryLight
        if !isCommaSeparated {
            textStyle.alignment = .right
        }
        
        return textStyle
    }
    
    
    // MARK: - Public methods
    
    func setRow(_ rows: [String], withAvailableSpace space: CGFloat? = nil) {
        self.rows = rows
        for row in rows {
            if row.contains(" ، ") {
                isCommaSeparated = true
                break
            }
        }
        
        if let space = space {
            availableSpace = space
        }
        
        if isCommaSeparated {
            rowWords = rowWords(from: rows)
            arrangeTextForCommaSeparated()
        } else {
            arrangeTextForDefault()
        }
    }
    
    
    // MARK: - Private methods
    
    private func rowWords(from rows: [String]?) -> [[String]]? {
        guard let rows = rows, !rows.isEmpty else { return nil }
        
        return rows.map{ $0.components(separatedBy: wordsSeparator) }
    }
    
    private func arrangeTextForCommaSeparated() {
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
                let isComma = word == "،"
                
                /// вычисляем размер текста, который необходимо добавить
                var textToAppend = word
                if !isLastInRow {
                    textToAppend += wordsSeparator
                }
                if isComma {
                    textToAppend += " "
                }
                /// для ، есть баг с вычислением размера, нужно вычислять еще с одним пробелом

                let attributedText = NSAttributedString(
                    string: textToAppend,
                    attributes: textStyle.textAttributes)
                let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
                var width = attributedText.boundingRect(
                    with: size,
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil)
                    .size
                    .width
                width = CGFloat(ceilf(Float(width)))
                
                /// если не осталось достаточно места в строке, переносим
                if space >= width {
                    space -= width
                } else {
                    topView = rightView
                    rightView = self
                    space = availableSpace - width
                }
                
                let pushableLabel = PushableLabel(
                    text: word,
                    normalTextAttributes: textStyle.textAttributes,
                    highlitedTextAttributes: highlitedTextStyle.textAttributes)
                pushableLabel.didPress = { [weak self] label in
                    self?.pushableLabelPressed(label)
                }
                pushableLabel.tag = counter
                pushableLabel.textAlignment = isComma ? .right : .natural
                pushableLabel.isUserInteractionEnabled = !isComma
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
                
                if !isLastInRow && !isComma {
                    let label = UILabel()
                    label.attributedText = NSAttributedString(
                        string: wordsSeparator,
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
    
    private func arrangeTextForDefault() {
        subviews.forEach { $0.removeFromSuperview() }
        
        guard let rows = rows, !rows.isEmpty else { return }
        
        var topView: UIView = self
        let count = rows.count
        
        for (index, row) in rows.enumerated() {
            let isLast = index == count - 1
            
            let pushableLabel = PushableLabel(
                text: row,
                normalTextAttributes: textStyle.textAttributes,
                highlitedTextAttributes: highlitedTextStyle.textAttributes)
            pushableLabel.didPress = { [weak self] label in
                self?.pushableLabelPressed(label)
            }
            pushableLabel.highlitedStateChanged = { [weak self] label in
                self?.pushableLabelDidChangeHighlitedState(label)
            }
            pushableLabel.tag = index
            addSubview(pushableLabel)
            pushableLabel.snp.makeConstraints { maker in
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                if topView == self {
                    maker.top.equalToSuperview()
                } else {
                    maker
                        .firstBaseline
                        .equalTo(topView.snp.lastBaseline)
                        .offset(Constants.spaceBetweenLines)
                }
                if isLast {
                    maker.bottom.equalToSuperview()
                }
            }
            
            topView = pushableLabel
        }
    }
    
    
    // MARK: - Actions
    
    private func pushableLabelPressed(_ label: PushableLabel) {
        delegate?.textView(self, didSelectWord: label.text, at: label.tag)
    }
    
    private func pushableLabelDidChangeHighlitedState(_ label: PushableLabel) {
        for subview in subviews {
            if let subview = subview as? PushableLabel {
                if subview.tag == label.tag, subview !== label {
                    subview.isHighlighted = label.isHighlighted
                }
            }
        }
    }
    
}
