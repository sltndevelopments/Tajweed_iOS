//
//  Created by Tagir Nafikov on 10/03/2018.
//

import UIKit
import Globus


class WritingByTranscriptionExerciseViewController: UIViewController, HasCompletion {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var correctWritingLabel: UILabel!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    
    
    // MARK: - Public properties
    
    var exercise: WritingByTranscriptionExercise!
    
    var completion: VoidClosure?

    
    // MARK: - Private properties
    
    private var transcriptionTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNext, size: 100)
        textStyle.color = .blackOne
        
        return textStyle
    }()
    
    private var correctWritingTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.simpleArabic, size: 100)
        textStyle.color = .blueberry
        
        return textStyle
    }()

    
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
        transcriptionLabel.attributedText = NSAttributedString(
            string: exercise.transcription,
            attributes: transcriptionTextStyle.textAttributes)
        correctWritingLabel.attributedText = NSAttributedString(
            string: exercise.correctWriting,
            attributes: correctWritingTextStyle.textAttributes)
        correctWritingLabel.isHidden = true

        actionButton.customImage = #imageLiteral(resourceName: "show")
        actionButton.customTitle = "ПРАВИЛЬНЫЙ ОТВЕТ"
    }


    // MARK: - Actions
    
    @IBAction func buttonPressed() {
        if correctWritingLabel.isHidden {
            correctWritingLabel.isHidden = false
            actionButton.customImage = #imageLiteral(resourceName: "next")
            actionButton.customTitle = "ДАЛЕЕ"
        } else {
            completion?()
        }
    }

}
