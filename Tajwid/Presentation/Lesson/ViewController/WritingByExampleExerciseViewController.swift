//
//  Created by Tagir Nafikov on 10/03/2018.
//


import UIKit
import Globus


class WritingByExampleExerciseViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    
    
    // MARK: - Public properties
    
    var exercise: WritingByExampleExercise!
    
    
    // MARK: - Private properties
    
    private var textStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.arialMT, size: 100)
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
        textLabel.attributedText = NSAttributedString(
            string: exercise.example,
            attributes: textStyle.textAttributes)
        
        actionButton.customImage = #imageLiteral(resourceName: "next")
        actionButton.customTitle = "ДАЛЕЕ"
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonPressed() {
    }

}
