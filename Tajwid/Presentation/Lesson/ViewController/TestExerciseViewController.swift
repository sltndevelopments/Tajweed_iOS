//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus


class TestExerciseViewController: BaseLessonViewController, HasCompletion {
    
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
    
    private var textStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.mainFont(ofSize: 24)
        textStyle.color = .blackOne
        
        return textStyle
    }

    private var correctVariantIndex: Int? {
        return exercise.variants.index(of: exercise.correctVariant)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.delaysContentTouches = scrollView.shouldScrollVerically
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
        
        configureLabels()

        let exerciseCount = exercise.variants.count
        
        for (index, button) in buttons.enumerated() {
            if index < exerciseCount {
                button.setTitle(exercise.variants[index], for: .normal)
            } else {
                button.isHidden = true
            }
        }
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
        actionButton.isHidden = true
    }
    
    private func configureLabels() {
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
    
    @objc func fontSettingsButtonPressed() {
        if isFontSettingsViewHidden {
            showFontSettingsView()
        } else {
            hideFontSettingsView()
        }
    }
    
}


extension TestExerciseViewController: FontAdjustmentsObserving {
    
    func beginObservingFontAdjustments() {
        FontCreator.addFontSizeAdjustmentsObserver(self)
    }
    
    func endObservingFontAdjustments() {
        FontCreator.removeFontSizeAdjustmentsObserver(self)
    }
    
    func adjustFontSize(to value: CGFloat) { }
    
    func changeFont(withName name: String, to anotherFontName: String) { }
    
    func fontSettingsChanged() {
        configureLabels()
    }
    
}


extension TestExerciseViewController: HasFontSettingsView { }
