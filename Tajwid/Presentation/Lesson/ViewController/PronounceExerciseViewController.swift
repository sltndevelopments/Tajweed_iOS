//
//  Created by Tagir Nafikov on 25/02/2018.
//

import UIKit
import Globus
import AVFoundation


class PronounceExerciseViewController: UIViewController, HasCompletion {
    
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
    
    var exercise: PronounceExercise!
    
    var completion: VoidClosure?
    
    
    // MARK: - Private properties
    
    private var audioPlayer: AVAudioPlayer?
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        addFontSettingsView()
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
        completion?()
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


extension PronounceExerciseViewController: HasFontSettingsView { }
