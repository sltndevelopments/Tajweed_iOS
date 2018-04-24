//
//  Created by Tagir Nafikov on 09/03/2018.
//

import UIKit
import SnapKit


enum PushableLabelState {
    case normal, wrong, right
}


class PushableLabel: UILabel {
    
    // MARK: - Public properties
    
    typealias PushableLabelClosure = (PushableLabel) -> Void
    
    var didPress: PushableLabelClosure?
    
    var state = PushableLabelState.normal {
        didSet {
            button.underscoreColor = underscoreColor
        }
    }
    
    var highlitedStateChanged: PushableLabelClosure?

    
    // MARK: - Private properties
    
    private let normalTextAttributes: [NSAttributedStringKey: Any]?
    
    private let highlitedTextAttributes: [NSAttributedStringKey: Any]?
    
    private let button: UnderscoredButton
    
    private let isUnderscoreHidden: Bool
    
    private var underscoreColor: UIColor {
        switch state {
        case .normal:
            return .whiteTwo
        case .wrong:
            return .deepRose
        case .right:
            return .shamrockGreen
        }
    }
    
    
    // MARK: - Init
    
    init(
        text: String?,
        normalTextAttributes: [NSAttributedStringKey: Any]?,
        highlitedTextAttributes: [NSAttributedStringKey: Any]?,
        isUnderscoreHidden: Bool = true) {
        
        self.normalTextAttributes = normalTextAttributes
        self.highlitedTextAttributes = highlitedTextAttributes
        self.button = UnderscoredButton()
        self.isUnderscoreHidden = isUnderscoreHidden
        
        super.init(frame: CGRect.zero)
        
        self.text = text
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = convert(point, to: button)
        return button.bounds.contains(convertedPoint) ? button : nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setupTextForHighlitedState()
            } else {
                setupTextForNormalState()
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func configure() {
        isUserInteractionEnabled = true
        numberOfLines = 0
        
        setupTextForNormalState()
        configureButton()
    }
    
    private func configureButton() {
        button.isUnderscoreHidden = isUnderscoreHidden
        if !isUnderscoreHidden {
            button.underscoreColor = underscoreColor
        }
        
        button.addTarget(
            self,
            action: #selector(buttonPressed),
            for: UIControlEvents.touchUpInside)
        button.highlitedStateChanged = { [weak self] isButtonHighlited in
            guard let `self` = self else { return }
            
            self.isHighlighted = isButtonHighlited
            self.highlitedStateChanged?(self)
        }
        addSubview(button)
        button.snp.makeConstraints { [weak self] maker in
            guard let `self` = self else { return }
            
            if self.isUnderscoreHidden {
                maker.edges.equalToSuperview()
            } else {
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.bottom.equalTo(self.snp.bottom).offset(19)
            }
        }
    }
    
    private func setupTextForNormalState() {
        if let attributes = normalTextAttributes, let text = text {
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    private func setupTextForHighlitedState() {
        if let attributes = highlitedTextAttributes, let text = text {
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func buttonPressed() {
        didPress?(self)
    }
    
}
