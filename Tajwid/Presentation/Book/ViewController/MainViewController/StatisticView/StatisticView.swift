//
//  StatisticView.swift
//  Tajwid
//
//  Created by Ha Sab on 16.03.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

final class StatisticView: UIView {
    
    // MARK: - Views
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
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
    
    func setup(by viewModels: [StatisticElementViewModel]) {
        stackView.removeFullyAllArrangedSubviews()
        for viewModel in viewModels {
            let statisticElementView = StatisticElementView()
            statisticElementView.setup(by: viewModel)
            stackView.addArrangedSubview(statisticElementView)
        }
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
