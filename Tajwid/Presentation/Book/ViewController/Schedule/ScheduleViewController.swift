//
//  ScheduleViewController.swift
//  Tajwid
//
//  Created by Ilnaz Mannapov on 15.10.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    private let listView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var groups: [Group] = []
    
    private let viewModel: ScheduleViewModelInterface
    
    // MARK: - Init
    
    init(viewModel: ScheduleViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeSycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "С учителем"
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getScheduleData { gr in
            self.groups = gr
            self.listView.reloadData()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        listView.dataSource = self
        listView.separatorColor = .white
        listView.allowsSelection = false
        
        self.view.addSubview(listView)
        
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),])
        
    }
    private var selectedGroup: Group? = nil
}


extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gSize = selectedGroup?.schedule.count ?? 0
        
        var size = 0
        
        if (gSize > 0) {
            size = gSize + 4
        } else {
            size = 3
        }
        
        return size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let c = TitleCell()
            c.setTitle(title: "Группы")
            
            return c
            
        } else if (indexPath.row == 1) {
            let c = GroupsSwitchCell(selector: { gr in
                let prev = self.selectedGroup
                
                self.selectedGroup = gr
                
                if (prev != self.selectedGroup) {
                    
                    self.listView.reloadData()
                }
            })
            c.setGroups(groups: groups, selected: selectedGroup)
            
            return c
        } else if (indexPath.row == 2) {
            let c = (tableView.dequeueReusableCell(withIdentifier: TitleCell.id) as? TitleCell) ?? TitleCell()
            c.setTitle(title: "Время занятий (по МСК)")
            
            return c
        } else if (indexPath.row == tableView.numberOfRows(inSection: 0) - 1) {
            let c = (tableView.dequeueReusableCell(withIdentifier: ButtonCell.id) as? ButtonCell) ?? ButtonCell()
            c.setButton(selector: {
                let dialog = UIAlertController(title: "Записаться", message: "Заявка на платные курсы будет отправлена в Исламский Центр Дар г. Москвы в отделение обучения Корана", preferredStyle: .actionSheet)
                
                dialog.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                dialog.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { a in
                    print("send action!")
                }))
                dialog.actions[1].isEnabled = false
                
                self.present(dialog, animated: true)
            })
            
            return c
        } else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: ScheduleCell.id) as? ScheduleCell) ?? ScheduleCell()
            cell.setSchedule(schedule: selectedGroup!.schedule[indexPath.row - 3], price: selectedGroup?.price ?? "")
            
            return cell
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

enum TableCellType {
    case group
    case shedule
    case footer
}
