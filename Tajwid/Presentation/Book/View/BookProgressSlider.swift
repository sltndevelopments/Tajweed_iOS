//
//  Created by Tagir Nafikov on 12/04/2018.
//

import UIKit


final class BookProgressSlider: UISlider {
    
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
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 3))
        progressView.backgroundColor = .blueberry
        setMinimumTrackImage(progressView.makeImage(), for: .normal)
        progressView.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        setMaximumTrackImage(progressView.makeImage(), for: .normal)
        
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 9))
        thumbView.backgroundColor = .blueberry
        setThumbImage(thumbView.makeImage(), for: .normal)
    }
    
    
    // MARK: - Override
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let halfHeight = bounds.height / 2
        return CGRect(x: 0, y: halfHeight - 1.5, width: bounds.width, height: 3)
    }

}
