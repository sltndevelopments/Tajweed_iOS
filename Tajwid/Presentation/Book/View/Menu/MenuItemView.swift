//
//  Created by Tagir Nafikov on 18/03/2018.
//

import UIKit
import DTModelStorage
import Globus


class MenuItemView: UIView, ModelTransfer {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var separtorView: UIView!
    
    @IBOutlet weak var button: StateChangesObservableButton! {
        didSet {
            button.highlitedStateChanged = highlitedStateChanged(_:)
        }
    }
    
    
    // MARK: - Public properties
    
    typealias MenuItemViewClosure = (MenuItemView) -> Void
    
    var didSelect: MenuItemViewClosure?
    
    
    // MARK: - Private properties
    
    private var titleTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNext, size: 24)
        textStyle.color = .blackOne
        textStyle.alignment = .center
        
        return textStyle
    }()


    
    // MARK: - ModelTransfer
    
    typealias ModelType = MenuItemViewModel
    
    func update(with model: MenuItemViewModel) {
        titleLabel.attributedText = NSAttributedString(
            string: model.title,
            attributes: titleTextStyle.textAttributes)
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.isSubtitleHidden
        separtorView.isHidden = model.isSeparatorHidden
    }
    
    
    // MARK: - Events
    
    private func highlitedStateChanged(_ isHighlited: Bool) {
        let alpha: CGFloat = isHighlited ? 0.5 : 1
        
        titleLabel.alpha = alpha
        subtitleLabel.alpha = alpha
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonPressed() {
        didSelect?(self)
    }
    
}
