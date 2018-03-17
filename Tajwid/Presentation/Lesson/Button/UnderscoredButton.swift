//
//  Created by Tagir Nafikov on 17/03/2018.
//

import UIKit
import SnapKit


class UnderscoredButton: StateChangesObservableButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let underscoreViewHeight = CGFloat(4)
    }
    

    
    // MARK: - Public properties
    
    var underscoreColor: UIColor? {
        didSet {
            underscoreView.backgroundColor = underscoreColor
        }
    }
    
    var isUnderscoreHidden = false {
        didSet {
            underscoreView.isHidden = isUnderscoreHidden
        }
    }
    

    // MARK: - Private properties
    
    let underscoreView: UIView

    
    // MARK: - Init
    
    override init(frame: CGRect) {
        underscoreView = UIView()
        
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    
    private func configure() {
        addSubview(underscoreView)
        underscoreView.isHidden = isUnderscoreHidden
        
        underscoreView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(Constants.underscoreViewHeight)
        }
    }
}
