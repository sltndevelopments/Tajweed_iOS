//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit
import DTModelStorage


class LessonSectionHeaderView: UIView, ModelTransfer {
    
    // MARK: - Outlets
    
    @IBOutlet weak var arabicTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        arabicTitleLabel.font = UIFont(name: FontNames.arialMT, size: 18)
    }
    
    
    // MARK: - ModelTransfer
    
    typealias ModelType = LessionSectionHeaderViewModel

    func update(with model: LessionSectionHeaderViewModel) {
        arabicTitleLabel.text = model.arabicText
        titleLabel.text = model.text
    }
    
}
