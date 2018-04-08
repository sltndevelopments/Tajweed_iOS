//
//  Created by Tagir Nafikov on 08/04/2018.
//

import UIKit


class FontSettingsView: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak var fontSizeSlider: FontSizeSlider!
    @IBOutlet weak var avenirButton: UIButton!
    @IBOutlet weak var georgiaButton: UIButton!
    
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fontSizeSlider.didChangeValue = fontSizeSliderValueChanged(_:)
        fontSizeSlider.value = Float(FontCreator.fontSizeAddition) + 2
        
        switch FontCreator.mainFontName {
        case .avenirNext:
            avenirButton.isSelected = true
            georgiaButton.isSelected = false
        case.georgia:
            avenirButton.isSelected = false
            georgiaButton.isSelected = true
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func avenitButtonPressed() {
        avenirButton.isSelected = true
        georgiaButton.isSelected = false
        
        FontCreator.mainFontName = .avenirNext
    }
    
    @IBAction func georgiaButtonPressed() {
        avenirButton.isSelected = false
        georgiaButton.isSelected = true
        
        FontCreator.mainFontName = .georgia
    }
    
    private func fontSizeSliderValueChanged(_ value: Float) {
        FontCreator.fontSizeAddition = CGFloat(value) - 2
    }
}
