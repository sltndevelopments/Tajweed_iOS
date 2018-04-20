//
//  Created by Tagir Nafikov on 14/04/2018.
//

import UIKit


class ProgressNavigationViewController: UINavigationController {
    
    // MARK: - Public properties
    
    var progressViewMaxiumumValue = Float(1) {
        didSet {
            progressSlider?.maximumValue = progressViewMaxiumumValue
        }
    }
    
    var progressViewValue = Float(0.5) {
        didSet {
            progressSlider?.value = progressViewValue
        }
    }


    // MARK: - Private properties
    
    private var progressSlider: LessonProgressSlider?
    
    
    // MARK: - Public methods
    
    func addProgressView() {
        let progressSlider = LessonProgressSlider()
        progressSlider.alpha = 0
        view.addSubview(progressSlider)
        progressSlider.maximumValue = progressViewMaxiumumValue
        progressSlider.value = progressViewValue
        progressSlider.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(3)
        }
        
        self.progressSlider = progressSlider
        
        UIView.animate(withDuration: 0.2) {
            progressSlider.alpha = 1
        }
    }
    
    func removeProgressView() {
        guard let progressSlider = progressSlider else { return }
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                progressSlider.alpha = 0
        },
            completion: { _ in
                progressSlider.removeFromSuperview()
                self.progressSlider = nil
        })
        
    }

}
