//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus
import AVFoundation


class PronounceExerciseViewController: BaseLessonViewController, HasCompletion {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: PronounceExerciseTextView! {
        didSet {
            textView.delegate = self
        }
    }
    
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    
    @IBOutlet weak var textViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var textViewTrailing: NSLayoutConstraint!
    
    
    // MARK: - Public properties
    
    var exercise: PronounceExercise! {
        didSet {
            correctExerciseText()
        }
    }
    
    var completion: VoidClosure?
    
    
    // MARK: - Private properties
    
    private var audioPlayer: AVAudioPlayer?
    
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

        configureTitleLabel()
        
        textView.setRow(exercise.rows, withAvailableSpace: availableSpace)
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
    }
    
    private func configureTitleLabel() {
        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)
    }
    
    
    // MARK: - Actions
    
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
 
    
    // MARK: - Helpers
    
    private func correctExerciseText() {
        var rows = [String]()
        
        for row in exercise.rows {
            var correctedRow = row.replacingOccurrences(of: " ،", with: " ، ")
            correctedRow = correctedRow.replacingOccurrences(of: " ،  ", with: " ، ")
            rows.append(correctedRow)
        }
        
        exercise.rows = rows
    }

}


extension PronounceExerciseViewController: PronounceExerciseTextViewDelegate {
    
    func textView(_ textView: PronounceExerciseTextView, didSelectWord word: String?, at index: Int) {
        guard let path = exercise.path,
            let url = Bundle.main.url(
                forResource: "\(path)_\(index + 1)",
                withExtension: "mp3")
            else {
                return
        }

        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }

        self.audioPlayer = audioPlayer
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
}


extension PronounceExerciseViewController: FontAdjustmentsObserving {
    
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
        textView.setRow(exercise.rows, withAvailableSpace: availableSpace)
    }
    
}


extension PronounceExerciseViewController: HasFontSettingsView { }
