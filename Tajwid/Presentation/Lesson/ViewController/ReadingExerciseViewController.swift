//
//  Created by Tagir Nafikov on 11/03/2018.
//

import UIKit
import Globus


class ReadingExerciseViewController: BaseLessonViewController, HasCompletion {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: ReadingExerciseTextView!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var textViewLeading: NSLayoutConstraint!

    
    // MARK: - Public properties
    
    var exercise: ReadingExercise!
    
    var completion: VoidClosure?

    
    // MARK: - Private properties
    
    private lazy var words: [String] = {
        var charachterSet = CharacterSet(charactersIn: " \n")
        return exercise.text.components(separatedBy: charachterSet)
    }()
    
    private lazy var correctWordIndexes: [Int] = {
        return findCorrectWordIndexes()
    }()
    
    private var availableSpace: CGFloat {
        return UIScreen.main.bounds.width - textViewLeading.constant - textViewTrailing.constant
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

        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)
        
        textView.didSelectWordWitnIndex = didSelectWordWithIndex(_:)
        textView.setText(exercise.text, withAvailableSpace: availableSpace)
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
    }
    
    private func configureTitleLabel() {
        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)
    }

    
    // MARK: - Private methods
    
    private func findCorrectWordIndexes() -> [Int] {
        var indexes = [Int]()
        
        for correctWord in exercise.correctWords {
            for (index, word) in words.enumerated() {
                if word == correctWord {
                    indexes.append(index)
                }
            }
        }
        
        return indexes
    }

    
    // MARK: - Actions
    
    func didSelectWordWithIndex(_ index: Int) {
        print(index)
        
        if correctWordIndexes.contains(index) {
            textView.markWords(at: [index], asCorrect: true)
        } else {
            textView.markWords(at: [index], asCorrect: false)
            textView.markWords(at: correctWordIndexes, asCorrect: true)

            textView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func buttonPressed() {
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


extension ReadingExerciseViewController: FontAdjustmentsObserving {
    
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
        textView.setText(exercise.text, withAvailableSpace: availableSpace)
    }
    
}


extension ReadingExerciseViewController: HasFontSettingsView { }
