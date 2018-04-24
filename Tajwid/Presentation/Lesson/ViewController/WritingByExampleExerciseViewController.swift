//
//  Created by Tagir Nafikov on 10/03/2018.
//


import UIKit
import Globus


class WritingByExampleExerciseViewController: BaseLessonViewController, HasCompletion {
    
    // MARK: - Constants
    
    private enum Constants {
        static let bigTextLabelTopSpace = CGFloat(50)
        static let smallTextLabelTopSpace = CGFloat(14)
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    @IBOutlet weak var textLabelTopSpace: NSLayoutConstraint!
    
    
    // MARK: - Public properties
    
    var exercise: WritingByExampleExercise!
    
    var completion: VoidClosure?

    
    // MARK: - Private properties
    
    private var bigTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.roboto, size: 100)
        textStyle.color = .blueberry
        textStyle.alignment = .center
        
        return textStyle
    }

    private var smallTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.roboto, size: 40)
        textStyle.color = .blueberry
        textStyle.alignment = .right
        textStyle.minimumLineHeight = 70
        
        return textStyle
    }
    
    private var isBigText: Bool {
        return exercise.example.count <= 5
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

        configureLabels()
        textLabelTopSpace.constant = isBigText
            ? Constants.bigTextLabelTopSpace : Constants.smallTextLabelTopSpace
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
    }
    
    private func configureLabels() {
        titleLabel.attributedText = NSAttributedString(
            string: exercise.title,
            attributes: GLBTextStyle.exerciseTitleTextStyle.textAttributes)
        textLabel.attributedText = NSAttributedString(
            string: exercise.example,
            attributes: isBigText ? bigTextStyle.textAttributes : smallTextStyle.textAttributes)
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

}


extension WritingByExampleExerciseViewController: FontAdjustmentsObserving {
    
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


extension WritingByExampleExerciseViewController: HasFontSettingsView { }
