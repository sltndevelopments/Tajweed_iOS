//
//  StatisticElementView.swift
//  Tajwid
//
//  Created by Ha Sab on 30.01.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

final class StatisticElementView: UIView {
    
    // MARK: - Properties
    
    var currentScore: Int = 0 {
        didSet {
            scoreLabel.text = "\(currentScore) / \(totalScore)"
        }
    }
    
    private var totalScore = 0
    
    // MARK: - Views
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textPrimary
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textSecondary
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .warmGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    convenience init(iconName: String, titleText: String, totalScore: Int) {
        self.init(frame: CGRect.zero)

        iconImageView.image = UIImage(named: iconName)
        titleLabel.text = titleText
        self.totalScore = totalScore
        scoreLabel.text = "\(currentScore) / \(totalScore)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUp() {
        let emptyView = UIView()
        
        let hStack = UIStackView(arrangedSubviews: [
            iconImageView,
            titleLabel,
            emptyView,
            scoreLabel
        ])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
