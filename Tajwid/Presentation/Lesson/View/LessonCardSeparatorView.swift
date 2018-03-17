//
//  Created by Tagir Nafikov on 17/02/2018.
//

import UIKit


class LessonCardSeparatorView: UIView {

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
        backgroundColor = .whiteOne
    }

}
