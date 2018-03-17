//
//  TestExerciseViewController.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 25/02/2018.
//  Copyright © 2018 teorius. All rights reserved.
//

import UIKit
import Globus


class TestExerciseViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet var buttons: [TestButton]!
    @IBOutlet weak var actionButton: ImageTitleVerticalButton!
    
    
    // MARK: - Public properties
    
    var exercise: TestExercise!
    
    
    // MARK: - Private properties
    
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
        textLabel.attributedText = NSAttributedString(
            string: exercise.text,
            attributes: textStyle.textAttributes)
        
        for (index, variant) in exercise.variants.enumerated() {
            let button = buttons[index]
            button.setTitle(variant, for: .normal)
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

}
