//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import SnapKit


class ImageTitleVerticalButton: UIButton {
    
    // MARK: - Public properties
    
    var customImage: UIImage? {
        didSet {
            customImageView.image = customImage
        }
    }
    
    var customTitle: String? {
        didSet {
            customTitleLabel.text = customTitle
        }
    }
    
    
    // MARK: - Private properties
    
    private var customImageView: UIImageView!
    private var customTitleLabel: UILabel!
    

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
        customImageView = UIImageView()
        addSubview(customImageView)
        customImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.leading.greaterThanOrEqualToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()
        }
        
        customTitleLabel = UILabel()
        customTitleLabel.font = UIFont(name: FontNames.pnSemibold, size: 10)
        customTitleLabel.textColor = .warmGray
        addSubview(customTitleLabel)
        customTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(customImageView.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.greaterThanOrEqualToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    
    // MARK: - Override
    
    override var isHighlighted: Bool {
        didSet {
            let alpha: CGFloat = isHighlighted ? 0.5 : 1
            self.alpha = alpha
        }
    }

}
