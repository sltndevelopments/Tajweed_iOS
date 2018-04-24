//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit


class TestButton: UIButton {
    
    // MARK: - Nested types
    
    enum TestButtonState {
        case normal, right, wrong
    }
    
    
    // MARK: - Public properties
    
    var testButtonState = TestButtonState.normal {
        didSet {
            setupColors()
        }
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
    
    
    // MARK: - Configuration
    
    private func configure() {
        beginObservingFontAdjustments()
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = FontCreator.fontWithName(FontNames.roboto, size: 40)
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
            return .warmGrey
        case .right:
            return .shamrockGreen
        case .wrong:
            return .blueberry
        }
    }
    
    private func textColorForCurrentState() -> UIColor {
        switch testButtonState {
        case .normal:
            return .blackOne
        case .right:
            return .shamrockGreen
        case .wrong:
            return .blueberry
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
        titleLabel?.font = FontCreator.fontWithName(FontNames.roboto, size: 40)
    }
    
}
