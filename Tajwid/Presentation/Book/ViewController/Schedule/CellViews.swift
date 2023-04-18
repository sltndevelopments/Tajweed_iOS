//
//  CellViews.swift
//  Tajwid
//
//  Created by Ilnaz Mannapov on 08.11.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import UIKit

class TitleCell: UITableViewCell {
    private let groupTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public static let id = "TitleCell"
    
    func setTitle(title: String) {
        groupTitleLabel.text = title
        contentView.addSubview(groupTitleLabel)
        NSLayoutConstraint.activate([
            //contentView.heightAnchor.constraint(equalToConstant: 50),
        groupTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        groupTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        groupTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        groupTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        //groupTitleLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}

class GroupsSwitchCell: UITableViewCell {
    private let groupsControl: UISegmentedControl = {
        let control = UISegmentedControl()
    
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    public static let id = "GroupsCell"
    
    private let groupChangeAction: (Group) -> ()
    private var groups: [Group] = []
    
    init(selector: @escaping (Group) -> ()) {
        self.groupChangeAction = selector
        
        super.init(style: .default, reuseIdentifier: GroupsSwitchCell.id)
        
        groupsControl.backgroundColor = UIColor.white
        groupsControl.addTarget(self, action: #selector(onSelectGroup), for: .valueChanged)
    }
    
    @objc
    func onSelectGroup() {
        let idx = groupsControl.selectedSegmentIndex
        
        if (idx >= 0 && idx < groups.count) {
            groupChangeAction(groups[idx])
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGroups(groups: [Group], selected: Group?) {
        self.groups = groups
        if (groups.isEmpty) {
            groupsControl.backgroundColor = UIColor.white
        }
        else {
            groupsControl.backgroundColor = UIColor.tabItemGreen
        }
        groupsControl.removeAllSegments()
        
        for i in groups.indices {
            groupsControl.insertSegment(withTitle: groups[i].name, at: i, animated: false)
        }
        
        if (groups.count > 0) {
            if (selected != nil) {
                let idx = groups.index(of: selected!)
                
                groupsControl.selectedSegmentIndex = idx ?? 0
                groupChangeAction(selected!)
            } else {
                groupsControl.selectedSegmentIndex = 0
                groupChangeAction(groups[0])
            }
        }
        
        contentView.addSubview(groupsControl)
        NSLayoutConstraint.activate([
            //contentView.heightAnchor.constraint(equalToConstant: 60),
            groupsControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            groupsControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            groupsControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            groupsControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

class ScheduleCell: UITableViewCell {
    private let weekDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let teacherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public static let id = "ScheduleCell"
    
    func setSchedule(schedule: Schedule, price: String) {
        weekDayLabel.text = schedule.day
        priceLabel.text = "\(price) руб"
        timeLabel.text = schedule.time
        teacherLabel.text = schedule.teacher
        contentView.addSubview(weekDayLabel)
        NSLayoutConstraint.activate([
            //contentView.heightAnchor.constraint(equalToConstant: 50),
            weekDayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            weekDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weekDayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            weekDayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        //groupTitleLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        contentView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            //contentView.heightAnchor.constraint(equalToConstant: 50),
            timeLabel.topAnchor.constraint(equalTo: weekDayLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        //groupTitleLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            //contentView.heightAnchor.constraint(equalToConstant: 50),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        //groupTitleLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        contentView.addSubview(teacherLabel)
        NSLayoutConstraint.activate([
            teacherLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            teacherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            teacherLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

class ButtonCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.cornerRadius = 22
        button.backgroundColor = .tabItemGreen
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Записаться", for: .normal)
        return button
    }()
    public static let id = "ButtonCell"
    private var buttonAction: (() -> ())? = nil
    
    init() {
        super.init(style: .default, reuseIdentifier: GroupsSwitchCell.id)
        
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    @objc
    func onClick() {
        buttonAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton(selector: @escaping () -> ()) {
        
        self.buttonAction = selector
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            //contentView.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        //groupTitleLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
