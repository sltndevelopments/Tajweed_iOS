//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit
import DTModelStorage


class LessonSectionHeaderView: UIView, ModelTransfer {
    
    // MARK: - Outlets
    
    @IBOutlet weak var arabicTitleLabelView: UIView!
    @IBOutlet weak var arabicTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    
    
    // MARK: - Init
    
    deinit {
        endObservingFontAdjustments()
    }
    
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        beginObservingFontAdjustments()
        
        arabicTitleLabel.font = FontCreator.fontWithName(FontNames.simpleArabic, size: 18)
        titleLabel.font = FontCreator.boldMainFont(ofSize: 10)
    }
    
    
    // MARK: - ModelTransfer
    
    typealias ModelType = LessionSectionHeaderViewModel

    func update(with model: LessionSectionHeaderViewModel) {
        arabicTitleLabel.text = model.arabicText
        arabicTitleLabelView.isHidden = arabicTitleLabel.text?.isEmpty ?? true
        titleLabel.text = model.text
    }
    
}


extension LessonSectionHeaderView: FontAdjustmentsObserving {
    
    func beginObservingFontAdjustments() {
        FontCreator.addFontSizeAdjustmentsObserver(self)
    }
    
    func endObservingFontAdjustments() {
        FontCreator.removeFontSizeAdjustmentsObserver(self)
    }
    
    func adjustFontSize(to value: CGFloat) {
        labels.forEach { label in
            label.font = UIFont(
                name: label.font.fontName,
                size: label.font.pointSize + value)
        }
    }
    
    func changeFont(withName name: String, to anotherFontName: String) {
        if anotherFontName == FontName.avenirNext.mediumFontName { return }
        
        if titleLabel.font.fontName == name {
            titleLabel.font = UIFont(
                name: anotherFontName,
                size: titleLabel.font.pointSize)
        }
    }
    
}
