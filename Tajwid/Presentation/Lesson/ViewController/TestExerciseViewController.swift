//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus


class TestExerciseViewController: UIViewController, HasCompletion {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet var buttons: [TestButton]!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    
    
    // MARK: - Public properties
    
    var exercise: TestExercise!
    
    var completion: VoidClosure?

    
    // MARK: - Private properties
    
    private var arabicTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.simpleArabic, size: 40)
        textStyle.color = .blackOne
        
        return textStyle
    }()

    private var textStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNext, size: 24)
        textStyle.color = .blackOne
        
        return textStyle
    }()

    private var correctVariantIndex: Int? {
        return exercise.variants.index(of: exercise.correctVariant)
    }

    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.delaysContentTouches = scrollView.shouldScrollVerically
    }

    
    // MARK: - Configuration
    
    private func configure() {
        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)
        if let text = exercise.text {
            textLabel.isHidden = false
            textLabel.attributedText = NSAttributedString(
                string: text,
                attributes: textStyle.textAttributes)
        } else {
            textLabel.isHidden = true
        }
        
        let exerciseCount = exercise.variants.count
        
        for (index, button) in buttons.enumerated() {
            if index < exerciseCount {
                let attributedText = NSAttributedString(
                    string: exercise.variants[index],
                    attributes: arabicTextStyle.textAttributes)
                button.setAttributedTitle(attributedText, for: .normal)
            } else {
                button.isHidden = true
            }
        }
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
        actionButton.isHidden = true
    }
    

    // MARK: - Actions
    
    @IBAction func buttonPressed(_ sender: TestButton) {
        guard let correctVariantIndex = self.correctVariantIndex else { return }
        
        if sender.tag == correctVariantIndex {
            sender.testButtonState = .right
        } else {
            sender.testButtonState = .wrong
            let correctVariantButton = buttons[correctVariantIndex]
            correctVariantButton.testButtonState = .right
        }
        
        buttons.forEach { $0.isEnabled = false }
        
        actionButton.isHidden = false
    }

    @IBAction func actionButtonPressed() {
        completion?()
    }
}
