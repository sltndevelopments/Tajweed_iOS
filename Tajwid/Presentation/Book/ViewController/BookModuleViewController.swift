//
//  Created by Tagir Nafikov on 18/03/2018.
//

import UIKit
import DTTableViewManager
import DTModelStorage


class BookModuleViewController: UIViewController, DTTableViewManageable {
    
    // MARK: - Constants
    
    private enum Segues {
        static let lessonCardsSegue = "lessonCards"
    }
    
    private enum Constants {
        static let estimatedRowHeight = CGFloat(144)
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = Constants.estimatedRowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
        }
    }
    
    
    // MARK: - Public properties
    
    var module: BookModule!
    
    
    // MARK: - Private properties
    
    private var selectedLesson: Lesson?
    

    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = module.title
        navigationItem.backBarButtonItem?.title = ""
        
        configureTableManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(
            false,
            animated: true)
        
        configureModels()
    }
    
    
    // MARK: - Configuration

    private func configureTableManager() {
        manager.startManaging(withDelegate: self)
        
        manager.configureEvents(for: BookModuleTableCell.self) { [weak self] cellType, modelType in
            guard let `self` = self else { return }
            
            manager.register(cellType)
            
            manager.didSelect(cellType) { _, _, indexPath in
                let lesson = self.module.lessons[indexPath.row]
                lesson.index = indexPath.row
                self.showLessonCardScreen(with: lesson)
            }
        
        }
    }
    
    private func configureModels() {
        var items = [BookModuleTableCellModel]()
        for (index, lesson) in module.lessons.enumerated() {
            let item = BookModuleTableCellModel(
                number: (index + 1),
                title: lesson.title,
                subtitle: lesson.description,
                isPassed: AppProgressManager.isItemDone(key: lesson.path))
            items.append(item)
        }
        
        manager.memoryStorage.setItems(items)
    }
    

    // MARK: - Segues
    
    private func showLessonCardScreen(with lesson: Lesson) {
        selectedLesson = lesson
        performSegue(withIdentifier: Segues.lessonCardsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == Segues.lessonCardsSegue,
            let vc = segue.destination as? LessonCardsViewController {
            vc.lesson = selectedLesson!
        }
    }

}
