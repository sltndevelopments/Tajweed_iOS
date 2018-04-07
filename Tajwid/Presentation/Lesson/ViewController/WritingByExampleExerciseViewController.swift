//
//  Created by Tagir Nafikov on 10/03/2018.
//


import UIKit
import Globus


class WritingByExampleExerciseViewController: UIViewController, HasCompletion {
    
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
    
    private var bigTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.simpleArabic, size: 100)
        textStyle.color = .blueberry
        textStyle.alignment = .center
        
        return textStyle
    }()

    private var smallTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.simpleArabic, size: 40)
        textStyle.color = .blueberry
        textStyle.alignment = .right
        textStyle.minimumLineHeight = 70
        
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
        let isBigText = exercise.example.count <= 5
        textLabel.attributedText = NSAttributedString(
            string: exercise.example,
            attributes: isBigText ? bigTextStyle.textAttributes : smallTextStyle.textAttributes)
        textLabelTopSpace.constant = isBigText
            ? Constants.bigTextLabelTopSpace : Constants.smallTextLabelTopSpace
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonPressed() {
        completion?()
    }

}
