//
//  Created by Tagir Nafikov on 31/03/2018.
//

import UIKit


class TrackProgressSlider: UISlider {
    
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
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 4))
        progressView.backgroundColor = .blueberry
        setMinimumTrackImage(progressView.makeImage(), for: .normal)
        progressView.backgroundColor = .whiteTwo
        setMaximumTrackImage(progressView.makeImage(), for: .normal)
        
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        thumbView.backgroundColor = .blueberry
        thumbView.cornerRadius = 6
        thumbView.isOpaque = false
        setThumbImage(thumbView.makeImage(), for: .normal)
    }
    

    // MARK: - Override

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let halfHeight = bounds.height / 2
        return CGRect(x: 0, y: halfHeight - 2, width: bounds.width, height: 4)
    }
}
