//
//  StatisticElementView.swift
//  Tajwid
//
//  Created by Ha Sab on 30.01.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

final class StatisticElementView: UIView {
    
    // MARK: - Views
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setup(by viewModel: StatisticElementViewModel) {
        iconImageView.image = viewModel.iconImage
        titleLabel.text = viewModel.titleText
        scoreLabel.text = "\(viewModel.currentScore)/\(viewModel.totalScore)"
    }
    
    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(scoreLabel)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            iconImageView.heightAnchor.constraint(equalToConstant: 35),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            scoreLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scoreLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
