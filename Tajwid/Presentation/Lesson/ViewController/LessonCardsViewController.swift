//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit
import DTModelStorage


class LessonCardsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let separatorHeight = CGFloat(20)
    }
    
    private enum Segues {
        static let testExerciseSegue = "testExerciseSegue"
        static let pronounceExerciseSegue = "pronounceExerciseSegue"
    }
    

    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.backgroundColor = .whiteOne
        }
    }
    var contentView: UIView!
    
    
    // MARK: - Private properties
    
    private var lesson: Lesson?
    private var models = [Any]()
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModels()
        addCards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(
            width: scrollView.contentSize.width,
            height: contentView.bounds.height)
        
//        performSegue(withIdentifier: Segues.pronounceExerciseSegue, sender: nil)
//        let vc = UIStoryboard.viewController(
//            ofType: ReadingExerciseViewController.self,
//            fromStoryboard: "Main")
//        for exercise in lesson!.exercises {
//            if let exercise = exercise as? ReadingExercise {
//                vc.exercise = exercise
//            }
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }

    
    // MARK: - Configuration
    
    private func setupModels() {
        if let url = Bundle.main.url(forResource: "Lesson", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let lesson = try JSONDecoder().decode(Lesson.self, from: data)
                
                lesson.sections.forEach { lessonSection in
                    let headerModel = LessionSectionHeaderViewModel(lessonSection: lessonSection)
                    models.append(headerModel)
                    
                    let cardModels: [Any] = lessonSection.cards.map {
                        return LessonCardViewModel(lessonCard: $0)
                    }
                    models.append(contentsOf: cardModels)
                }
                
                self.lesson = lesson
            }
            catch {
                print(error)
            }
        }
    }
    
    private func addCards() {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.greaterThanOrEqualToSuperview()
        }
        
        var prevView: UIView! = contentView
        
        models.forEach { model in
            if let model = model as? LessionSectionHeaderViewModel {
                guard let view = UIView.loadFromXib(type: LessonSectionHeaderView.self)
                    else {
                        return
                }
                
                view.update(with: model)
                contentView.addSubview(view)
                view.snp.makeConstraints { maker in
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    
                    if prevView === contentView {
                        maker.top.equalToSuperview()
                    } else {
                        maker.top.equalTo(prevView.snp.bottom)
                    }
                }

                prevView = view
            } else if let model = model as? LessonCardViewModel {
                if prevView is LessonCardView {
                    let separator = LessonCardSeparatorView()
                    contentView.addSubview(separator)
                    separator.snp.makeConstraints { maker in
                        maker.leading.equalToSuperview()
                        maker.trailing.equalToSuperview()
                        maker.top.equalTo(prevView.snp.bottom)
                        maker.height.equalTo(Constants.separatorHeight)
                    }
                    
                    prevView = separator
                }
                
                let view = LessonCardView()
                view.update(with: model)
                contentView.addSubview(view)
                view.snp.makeConstraints { maker in
                    maker.leading.equalToSuperview()
                    maker.trailing.equalToSuperview()
                    if prevView === contentView {
                        maker.top.equalToSuperview()
                    } else {
                        maker.top.equalTo(prevView.snp.bottom)
                    }
                }
                
                prevView = view
            }
        }
        
        if lesson?.exercises.isEmpty == false {
            let button = ImageTitleVerticalButton()
            button.customImage = #imageLiteral(resourceName: "next")
            button.customTitle = "ПЕРЕЙТИ К УПРАЖНЕНИЯМ"
            contentView.addSubview(button)
            button.snp.makeConstraints { maker in
                maker.top.equalTo(prevView.snp.bottom).offset(32)
                maker.centerX.equalToSuperview()
                maker.bottom.equalToSuperview().offset(-27)
            }
        } else {
            prevView.snp.makeConstraints { maker in
                maker.bottom.equalToSuperview().offset(-20)
            }
        }
    }
    
    private func addFooter() {
        
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let lesson = lesson else { return }
        
        if segue.identifier == Segues.testExerciseSegue,
            let vc = segue.destination as? TestExerciseViewController {
            for exercise in lesson.exercises {
                if let testExercise = exercise as? TestExercise {
                    vc.exercise = testExercise
                }
            }
        } else if segue.identifier == Segues.pronounceExerciseSegue,
            let vc = segue.destination as? PronounceExerciseViewController {
            for exercise in lesson.exercises {
                if let pronounceExercise = exercise as? PronounceExercise {
                    vc.exercise = pronounceExercise
                }
            }
        }
    }
    
}
