//
//  MainViewController.swift
//  Tajwid
//
//  Created by Ha Sab on 30.01.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: MainViewModelInterface
    
    // MARK: - Views
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .textSecondary
        return label
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .black)
        label.textColor = .textPrimary
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let statisticView: StatisticView = {
        let view = StatisticView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let introTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .textPrimary
        return label
    }()
    
    private let introDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()
    
    private let teacherButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 22
        button.backgroundColor = .tabItemGreen
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: MainViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    // MARK: - Methods
    
    private func setup() {
        view.backgroundColor = .mainBackground
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        authorLabel.text = viewModel.authorText
        logoLabel.text = viewModel.logoText
        logoImageView.image = viewModel.logoImage
        introTitleLabel.text = viewModel.introTitleText
        introDescriptionLabel.text = viewModel.introDescriptionText
        teacherButton.setTitle(viewModel.buttonTitleText, for: .normal)
        teacherButton.addTarget(self, action: #selector(teacherButtonTap), for: .touchUpInside)
        updateStatistics()
    }
    
    private func setupConstraints() {
        let logoLabelsStack = UIStackView(arrangedSubviews: [authorLabel, logoLabel])
        logoLabelsStack.alignment = .leading
        logoLabelsStack.axis = .vertical
        logoLabelsStack.spacing = 0
        logoLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let logoStack = UIStackView(arrangedSubviews: [UIView(), logoImageView, logoLabelsStack, UIView()])
        logoStack.axis = .horizontal
        logoStack.alignment = .center
        logoStack.spacing = 8
        logoStack.translatesAutoresizingMaskIntoConstraints = false
        
        let introStack = UIStackView(arrangedSubviews: [introTitleLabel, introDescriptionLabel, teacherButton])
        introStack.alignment = .leading
        introStack.axis = .vertical
        introStack.spacing = 8
        introStack.setCustomSpacing(16, after: introDescriptionLabel)
        introStack.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoStack)
        contentView.addSubview(statisticView)
        contentView.addSubview(introStack)
        
        let authorLabelHeight = authorLabel.intrinsicContentSize.height
        let logoLabelHeight = logoLabel.intrinsicContentSize.height
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            logoImageView.heightAnchor.constraint(equalToConstant: authorLabelHeight + logoLabelHeight),
            
            statisticView.topAnchor.constraint(equalTo: logoStack.bottomAnchor, constant: 40),
            statisticView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statisticView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            introStack.topAnchor.constraint(equalTo: statisticView.bottomAnchor, constant: 40),
            introStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 67),
            introStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            introStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            teacherButton.heightAnchor.constraint(equalToConstant: 44),
            teacherButton.widthAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func updateStatistics() {
        let statisticViewModels = viewModel.getStatisticViewModels()
        statisticView.setup(by: statisticViewModels)
    }
    
    // MARK: - Actions
    
    @objc
    private func teacherButtonTap() {
        viewModel.teacherButtonTap()
    }
}
