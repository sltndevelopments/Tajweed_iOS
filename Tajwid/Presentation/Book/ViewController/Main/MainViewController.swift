//
//  MainViewController.swift
//  Tajwid
//
//  Created by Ha Sab on 30.01.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MainViewModelInterface
    
    // MARK: - Views
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ильдар Аляутдинов"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .textSecondary
        return label
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "TAJWEED"
        label.font = .systemFont(ofSize: 32, weight: .black)
        label.textColor = .textPrimary
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tajweed_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    
    init(viewModel: MainViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Methods
    
    private func setUp() {
        view.backgroundColor = .mainBackground
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let logoLabelsStack = UIStackView(arrangedSubviews: [authorLabel, logoLabel])
        logoLabelsStack.alignment = .leading
        logoLabelsStack.axis = .vertical
        logoLabelsStack.spacing = 0
        logoLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let logoStack = UIStackView(arrangedSubviews: [UIView(), logoImageView, logoLabelsStack, UIView()])
        logoStack.axis = .horizontal
        logoStack.spacing = 8
        logoStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoStack)
        
        let authorLabelHeight = authorLabel.intrinsicContentSize.height
        let logoLabelHeight = logoLabel.intrinsicContentSize.height
        
        NSLayoutConstraint.activate([
            logoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoImageView.heightAnchor.constraint(equalToConstant: authorLabelHeight + logoLabelHeight),
        ])
    }
    
    // MARK: - Actions
}
