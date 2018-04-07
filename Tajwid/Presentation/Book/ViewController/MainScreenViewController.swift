//
//  Created by Tagir Nafikov on 17/03/2018.
//

import UIKit


class MainScreenViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Segues {
        static let bookModuleSegue = "bookModule"
    }


    // MARK: - Outlets
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var menuView: MenuView!
    
    
    // MARK: - Private properties
    
    private var book: Book!
    private var menuItems: [MenuItem]!
    private var selectedModule: BookModule?
    
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        obtainBook()
        indexBook()
        createMenuItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        obtainBook()
        indexBook()
        createMenuItems()
    }
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        automaticallyAdjustsScrollViewInsets = false
        
        menuView.items = menuItems
        menuView.didSelectItem = didSelectItem(_:)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(
            true,
            animated: !isMovingToParentViewController)
    }
    
    
    // MARK: - Configuration
    
    private func obtainBook() {
        if let url = Bundle.main.url(forResource: "Book", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                book = try JSONDecoder().decode(Book.self, from: data)
            }
            catch {
                print(error)
                fatalError("Couldn't obtain a book model from the book json!")
            }
        } else {
            fatalError("Couldn't obtain a book json!")
        }
    }
    
    private func indexBook() {
        for (index, module) in book.modules.enumerated() {
            module.index = index
            module.path = String(index + 1)
            
            for (index, lesson) in module.lessons.enumerated() {
                lesson.index = index
                lesson.path = "\(module.path!)_\(index + 1)"
                
                var cardsCount = 0
                for section in lesson.sections {
                    for (index, card) in section.cards.enumerated() {
                        let index = index + cardsCount
                        card.index = index
                        card.path = "\(lesson.path!)_\(index + 1)"
                    }
                    
                    cardsCount += section.cards.count
                }
                
                for (index, exercise) in lesson.exercises.enumerated() {
                    let index = index + cardsCount
                    exercise.index = index
                    exercise.path = "\(lesson.path!)_\(index + 1)"
                }
            }
        }
    }
    
    private func createMenuItems() {
        menuItems = [MenuItem]()
        
        for module in book.modules {
            let title = module.title
            let subtitle = "ПРОЙДЕНО 1 ИЗ 12"
            
            let item = MenuItem(
                type: .module(module),
                title: title,
                subtitle: subtitle)
            menuItems.append(item)
        }
        
        let settingsItem = MenuItem(
            type: .settings,
            title: "Настройки",
            subtitle: nil)
        menuItems.append(settingsItem)
    }
    
    
    // MARK: - Actions
    
    private func didSelectItem(_ item: MenuItem) {
        switch item.type {
        case .module(let module):
            showModuleScreen(with: module)
        case .settings:
            break
        }
    }
    
    
    // MARK: - Segues
    
    private func showModuleScreen(with module: BookModule) {
        selectedModule = module
        performSegue(withIdentifier: Segues.bookModuleSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == Segues.bookModuleSegue,
            let vc = segue.destination as? BookModuleViewController {
            vc.module = selectedModule!
        }
    }
    
}


extension MainScreenViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
}
