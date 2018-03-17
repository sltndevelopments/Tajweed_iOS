//
//  Created by Tagir Nafikov on 11/03/2018.
//

import UIKit
import Globus


class ReadingExerciseViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: ReadingExerciseTextView!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var textViewLeading: NSLayoutConstraint!

    
    // MARK: - Public properties
    
    var exercise: ReadingExercise!
    
    
    // MARK: - Private properties
    
    private lazy var words: [String] = {
        var charachterSet = CharacterSet(charactersIn: " \n")
        return exercise.text.components(separatedBy: charachterSet)
    }()
    
    private lazy var correctWordIndexes: [Int] = {
        return findCorrectWordIndexes()
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
        
        let space = UIScreen.main.bounds.width - textViewLeading.constant - textViewTrailing.constant
        textView.didSelectWordWitnIndex = didSelectWordWithIndex(_:)
        textView.setText(exercise.text, withAvailableSpace: space)
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
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
        if correctWordIndexes.contains(index) {
            textView.markWords(at: [index], asCorrect: true)
        } else {
            textView.markWords(at: [index], asCorrect: false)
            textView.markWords(at: correctWordIndexes, asCorrect: true)
            
            textView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func buttonPressed() {
    }
    
}
