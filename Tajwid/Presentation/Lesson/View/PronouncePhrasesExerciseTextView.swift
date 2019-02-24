//
//  PronouncePhrasesExerciseTextView.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 24/02/2019.
//  Copyright © 2019 teorius. All rights reserved.
//

import UIKit
import Globus


protocol PronouncePhrasesExerciseTextViewDelegate: class {
    
    func textView(_ textView: PronouncePhrasesExerciseTextView, didSelectWord word: String?, at index: Int)
    
}


class PronouncePhrasesExerciseTextView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let spaceBetweenLines = CGFloat(70)
        static let hitEdgeInsets = UIEdgeInsets(top: -5, left: -10, bottom: -5, right: -10)
    }
    
    
    // MARK: - Public properties
    
    weak var delegate: PronouncePhrasesExerciseTextViewDelegate?

    
    // MARK: - Private properties
    
    private var rows: [String]? {
        didSet {
            arrangeText()
        }
    }

    private var textStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.arabic, size: 40)
        textStyle.color = .blueberry
        
        return textStyle
    }
    
    private var highlitedTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.arabic, size: 40)
        textStyle.color = .blueberryLight
        
        return textStyle
    }

    
    // MARK: - Private methods
    
    private func arrangeText() {
        subviews.forEach { $0.removeFromSuperview() }
        
        guard let rows = rows, !rows.isEmpty else { return }
        
        var topView: UIView = self
        
        for (index, row) in rows.enumerated() {
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
                maker.top.equalTo(topView.snp.bottom).offset(Constants.spaceBetweenLines)
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
