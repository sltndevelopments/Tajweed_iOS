//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus


class PronounceExerciseViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: PronounceExerciseTextView!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    @IBOutlet weak var textViewLeading: NSLayoutConstraint!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    
    
    // MARK: - Public properties
    
    var exercise: PronounceExercise!
    

    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    
    // MARK: - Configuration
    
    private func configure() {
        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)

        let space = UIScreen.main.bounds.width - textViewLeading.constant - textViewTrailing.constant
        textView.setRow(exercise.rows, withAvailableSpace: space)
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
    }

    
    // MARK: - Actions
    
    @IBAction func buttonPressed() {
    }
    
}
