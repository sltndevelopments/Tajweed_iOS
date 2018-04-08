//
//  Created by Tagir Nafikov on 08/04/2018.
//

import UIKit
import SnapKit


class FontSizeSlider: UISlider {
    
    // MARK: - Constants
    
    private enum Constants {
        static let dotSize = CGFloat(7)
        static let dotY = CGFloat(3)
        static let steps = 4
    }
    
    
    // MARK: - Public properties
    
    typealias ValueChangedClosure = (Float) -> Void
    
    var didChangeValue: ValueChangedClosure?
    

    // MARK: - Private properties
    
    private var dotViews = [UIView]()
    
    private var steps: Float {
        return Float(Constants.steps)
    }
    
    private var dotXStep: CGFloat {
        return bounds.width / CGFloat(steps)
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
    
    
    // MARK: - Private methods
    
    private func configure() {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        maximumValue = steps
        
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 3))
        progressView.backgroundColor = .blueberry
        setMinimumTrackImage(progressView.makeImage(), for: .normal)
        progressView.backgroundColor = .warmGrey
        setMaximumTrackImage(progressView.makeImage(), for: .normal)
        
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 13))
        thumbView.backgroundColor = .blueberry
        thumbView.cornerRadius = 6.5
        thumbView.isOpaque = false
        setThumbImage(thumbView.makeImage(), for: .normal)
        
        addDots()
    }
    
    private func addDots() {
        for i in 0...Constants.steps {
            let dot = UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: Constants.dotSize,
                    height: Constants.dotSize))
            dot.cornerRadius = Constants.dotSize / 2
            dot.tag = i
            dot.isUserInteractionEnabled = false
            insertSubview(dot, at: 0)
            dotViews.append(dot)
        }
        
        updateDotColors()
    }
    
    private func originForDot(at index: Int) -> CGPoint {
        if index == 0 { return CGPoint(x: 0, y: Constants.dotY) }
        if index == Constants.steps { return CGPoint(x: bounds.width - Constants.dotSize, y: Constants.dotY) }
        return CGPoint(x: dotXStep * CGFloat(index) - Constants.dotSize / 2, y: Constants.dotY)
    }
    
    private func updateDotColors() {
        for dot in dotViews {
            dot.backgroundColor = Float(dot.tag) > value ? .warmGrey : .blueberry
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func valueChanged() {
        value = roundf(value)
        updateDotColors()
        didChangeValue?(value)
    }
    
    
    // MARK: - Override
    
    override var value: Float {
        didSet {
            updateDotColors()
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let halfHeight = bounds.height / 2
        return CGRect(x: 0, y: halfHeight - 1.5, width: bounds.width, height: 3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for dot in dotViews {
            dot.frame.origin = originForDot(at: dot.tag)
        }
    }

}
