//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit


class TestButton: UIButton {
    
    // MARK: - Nested types
    
    enum TestButtonState {
        case normal, right, wrong
    }
    
    private enum Constants {
        static let titleInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    // MARK: - Public class properties
    
    static var recommendedWidth = UIScreen.main.bounds.width - 30
    static var minimumHeight = CGFloat(70)

    
    // MARK: - Public properties
    
    var testButtonState = TestButtonState.normal {
        didSet {
            setupColors()
        }
    }
    
    var fontSize = CGFloat(40) {
        didSet {
            titleLabel?.font = defaultFont
        }
    }

    
    // MARK: - Private properties
    
    private var defaultFont: UIFont {
        return FontCreator.fontWithName(FontNames.arabic, size: fontSize) ?? UIFont()
    }
    

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    deinit {
        endObservingFontAdjustments()
    }
    
    
    // MARK: - Public methods
    
    func heightForTitle(_ title: String) -> CGFloat {
        let width = TestButton.recommendedWidth - titleEdgeInsets.left - titleEdgeInsets.right
        let attributedText = NSAttributedString(
            string: title,
            attributes: [.font: defaultFont])
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        var height = attributedText.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil)
            .size
            .height
        height = CGFloat(ceil(Double(height)))
        height += titleEdgeInsets.top
        height += titleEdgeInsets.bottom
        height = max(height, TestButton.minimumHeight)
        
        return height
    }
    

    // MARK: - Override
    
    override var intrinsicContentSize: CGSize {
        guard let text = titleLabel?.text
            else {
                return CGSize(width: TestButton.recommendedWidth, height: TestButton.minimumHeight)
        }
        
        let height = heightForTitle(text)
        return CGSize(width: TestButton.recommendedWidth, height: height)
    }
    
    // MARK: - Configuration
    
    private func configure() {
        beginObservingFontAdjustments()
        
        titleEdgeInsets = Constants.titleInsets
        
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
        titleLabel?.font = defaultFont
        borderWidth = 1
        cornerRadius = 3
        
        setupColors()
    }
    
    private func setupColors() {
        setTitleColor(textColorForCurrentState(), for: .normal)
        borderColor = borderColorForCurrentState()
    }
    

    // MARK: - Private methods
    
    private func borderColorForCurrentState() -> UIColor {
        switch testButtonState {
        case .normal:
            return .warmGray
        case .right:
            return .shamrockGreen
        case .wrong:
            return .redOne
        }
    }
    
    private func textColorForCurrentState() -> UIColor {
        switch testButtonState {
        case .normal:
            return .blackOne
        case .right:
            return .shamrockGreen
        case .wrong:
            return .redOne
        }
    }
    
}


extension TestButton: FontAdjustmentsObserving {
    
    func beginObservingFontAdjustments() {
        FontCreator.addFontSizeAdjustmentsObserver(self)
    }
    
    func endObservingFontAdjustments() {
        FontCreator.removeFontSizeAdjustmentsObserver(self)
    }
    
    func adjustFontSize(to value: CGFloat) { }
    
    func changeFont(withName name: String, to anotherFontName: String) { }
    
    func fontSettingsChanged() {
        titleLabel?.font = defaultFont
    }
    
}
