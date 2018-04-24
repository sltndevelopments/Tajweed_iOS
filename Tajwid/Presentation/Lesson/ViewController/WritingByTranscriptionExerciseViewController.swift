//
//  Created by Tagir Nafikov on 10/03/2018.
//

import UIKit
import Globus


class WritingByTranscriptionExerciseViewController: BaseLessonViewController, HasCompletion {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var correctWritingLabel: UILabel!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    @IBOutlet weak var labelsContentViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Public properties
    
    var exercise: WritingByTranscriptionExercise!
    
    var completion: VoidClosure?

    
    // MARK: - Private properties
    
    private var transcriptionTextStyle: GLBTextStyle = {
        let fontSize: CGFloat
        switch UIDevice.current.screenType {
        case .screen3_5:
            fontSize = 45
        case .screen4:
            fontSize = 60
        case .screen4_7, .screen5_5, .screen5_8, .other:
            fontSize = 100
        }
        
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNext, size: fontSize)
        textStyle.color = .blackOne
        
        return textStyle
    }()
    
    private var correctWritingTextStyle: GLBTextStyle = {
        let fontSize: CGFloat
        switch UIDevice.current.screenType {
        case .screen3_5:
            fontSize = 60
        case .screen4:
            fontSize = 80
        case .screen4_7, .screen5_5, .screen5_8, .other:
            fontSize = 100
        }

        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.roboto, size: fontSize)
        textStyle.color = .blueberry
        
        return textStyle
    }()
    
    private var labelsContentViewHeight: CGFloat {
        switch UIDevice.current.screenType {
        case .screen3_5:
            return 135
        case .screen4:
            return 185
        case .screen4_7, .screen5_5, .screen5_8, .other:
            return 300
        }
    }
    
    
    // MARK: - Init
    
    deinit {
        endObservingFontAdjustments()
    }

    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginObservingFontAdjustments()
        
        configure()
        addFontSettingsView()
    }
    
    
    // MARK: - Configuration
    
    private func configure() {
        let barButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "font-settings"),
            style: .plain,
            target: self,
            action: #selector(fontSettingsButtonPressed))
        barButtonItem.tintColor = .blueberry
        navigationItem.rightBarButtonItem = barButtonItem

        labelsContentViewHeightConstraint.constant = labelsContentViewHeight
        
        configureTitleLabel()
        transcriptionLabel.adjustsFontSizeToFitWidth = true
        transcriptionLabel.attributedText = NSAttributedString(
            string: exercise.transcription,
            attributes: transcriptionTextStyle.textAttributes)
        correctWritingLabel.adjustsFontSizeToFitWidth = true
        correctWritingLabel.attributedText = NSAttributedString(
            string: exercise.correctWriting,
            attributes: correctWritingTextStyle.textAttributes)
        correctWritingLabel.isHidden = true

        actionButton.customImage = #imageLiteral(resourceName: "show")
        actionButton.customTitle = "ПРАВИЛЬНЫЙ ОТВЕТ"
    }
    
    private func configureTitleLabel() {
        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)
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

    @objc func fontSettingsButtonPressed() {
        if isFontSettingsViewHidden {
            showFontSettingsView()
        } else {
            hideFontSettingsView()
        }
    }

}


extension WritingByTranscriptionExerciseViewController: FontAdjustmentsObserving {
    
    func beginObservingFontAdjustments() {
        FontCreator.addFontSizeAdjustmentsObserver(self)
    }
    
    func endObservingFontAdjustments() {
        FontCreator.removeFontSizeAdjustmentsObserver(self)
    }
    
    func adjustFontSize(to value: CGFloat) { }
    
    func changeFont(withName name: String, to anotherFontName: String) { }
    
    func fontSettingsChanged() {
        configureTitleLabel()
    }
    
}


extension WritingByTranscriptionExerciseViewController: HasFontSettingsView { }
