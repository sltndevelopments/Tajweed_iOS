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
    
    
    // MARK: - Configuration
    
    private func configure() {
        titleLabel?.font = UIFont(name: FontNames.simpleArabic, size: 40)
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
