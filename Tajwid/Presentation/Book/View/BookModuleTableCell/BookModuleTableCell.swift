//
//  Created by Tagir Nafikov on 18/03/2018.
//

import UIKit
import DTModelStorage


class BookModuleTableCell: UITableViewCell, ModelTransfer {
    
    // MARK: - Outlets
    
    @IBOutlet weak var numberView: UIView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    // MARK: - ModelTransfer
    
    typealias ModelType = BookModuleTableCellModel
    
    func update(with model: BookModuleTableCellModel) {
        selectionStyle = .none
        
        numberView.backgroundColor = model.isPassed ? .blackOne : .white
        numberLabel.textColor = model.isPassed ? .white : .blackOne
        numberLabel.text = String(model.number)
        titleLabel.text = model.title
        titleLabel.font = model.titleFont
        subtitleLabel.text = model.subtitle
        subtitleLabel.font = model.subtitleFont
    }
    
    
    // MARK: - Override
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        alpha = highlighted ? 0.5 : 1
    }

}
