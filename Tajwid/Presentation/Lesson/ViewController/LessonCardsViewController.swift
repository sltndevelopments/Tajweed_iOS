//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit
import DTModelStorage
import AVFoundation
import SnapKit


class LessonCardsViewController: BaseLessonViewController {
    
    // MARK: - Nested types
    
    private enum PlayerMode {
        case normal, fastForward, fastBackward
    }

    private enum Constants {
        static let separatorHeight = CGFloat(20)
        static let soundDurationMultiplier = 10.0
    }
    
    private enum Segues {
        static let testExerciseSegue = "testExerciseSegue"
        static let pronounceExerciseSegue = "pronounceExerciseSegue"
    }
    

    // MARK: - Outlets
    
    @IBOutlet weak var playerContainerView: UIView!
    
    @IBOutlet weak var playerLineView: UIView!
    
    @IBOutlet weak var playerContainerViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.backgroundColor = .whiteOne
        }
    }
    
    var contentView: UIView!
    
    
    // MARK: - Public properties
    
    var lesson: Lesson!

    
    // MARK: - Private properties
    
    private var playerView: SoundPlayerView! {
        didSet {
            playerView.soundDurationMultiplier = Constants.soundDurationMultiplier
        }
    }
    
    private var models = [Any]()
    
    private var audioPlayer: AVAudioPlayer?
    
    private var currentPlayingCardIndex = 0
    
    private var isPlayerOnScreen: Bool {
        return playerContainerViewYConstraint.constant == 0
    }
    
    private var hasPreviousSound: Bool {
        var index = currentPlayingCardIndex - 1
        
        while index >= 0  {
            let card = lesson.cards[index]
            if card.soundURL != nil { return true }
            index -= 1
        }
        
        return false
    }
    
    private var hasNextSound: Bool {
        var index = currentPlayingCardIndex + 1
        let count = lesson.cards.count
        
        while index < count  {
            let card = lesson.cards[index]
            if card.soundURL != nil { return true }
            index += 1
        }
        
        return false
    }

    private var playingTimer: Timer?
    
    private var playerMode = PlayerMode.normal
    
    private var cardViews = [LessonCardView]()
    
    private var currentPlayingCardView: LessonCardView? {
        return cardView(at: currentPlayingCardIndex)
    }
    
    private var needToShowProgressSlider: Bool {
        return !lesson.exercises.isEmpty
    }
    
    private var progressNavigationController: ProgressNavigationViewController? {
        return navigationController as? ProgressNavigationViewController
    }
    
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = lesson.index {
            title = "Урок \(index + 1)"
        }
        
        configureSounds()
        configureUI()
        configureModels()
        addCards()
        addFontSettingsView()
        addProgressSliderIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let vc = UIStoryboard.viewController(
//            ofType: WritingByTranscriptionExerciseViewController.self,
//            fromStoryboard: "Main")
//        for exercise in lesson!.exercises {
//            if let exercise = exercise as? WritingByTranscriptionExercise {
//                vc.exercise = exercise
//            }
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParentViewController {
            removeProgressSliderIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let deadlineTime = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.adjustScrollContentSize()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParentViewController {
            stopTimer()
        } else {
            if audioPlayer?.isPlaying != false {
                audioPlayer?.pause()
                playerView.isPlaying = false
            }
        }
    }
    
    
    // MARK: - Configuration
    
    private func configureSounds() {
        for card in lesson.cards {
            guard let url = Bundle.main.url(forResource: card.path, withExtension: "mp3"),
                let audioPlayer = try? AVAudioPlayer(contentsOf: url),
                audioPlayer.duration > 1
                else {
                    continue
            }
            card.soundURL = url
        }
    }
    
    private func configureUI() {
        let barButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "font-settings"),
            style: .plain,
            target: self,
            action: #selector(fontSettingsButtonPressed))
        barButtonItem.tintColor = .blueberry
        navigationItem.rightBarButtonItem = barButtonItem
        
        playerView = UIView.loadFromXib(type: SoundPlayerView.self)
        playerView.delegate = self
        playerView.backgroundColor = .whiteOne
        playerContainerView.addSubview(playerView)
        playerView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalTo(playerLineView.snp.top)
        }
    }
    
    private func configureModels() {
        lesson.sections.forEach { lessonSection in
            let headerModel = LessionSectionHeaderViewModel(lessonSection: lessonSection)
            models.append(headerModel)
            
            let cardModels: [Any] = lessonSection.cards.map {
                return LessonCardViewModel(lessonCard: $0)
            }
            models.append(contentsOf: cardModels)
        }
    }
    
    // MARK: - Actions
    
    @objc func nextButtonPressed() {
        showExerciseViewControllerWithContainer(at: 0)
    }
    
    @objc func fontSettingsButtonPressed() {
        if isFontSettingsViewHidden {
            showFontSettingsView()
        } else {
            hideFontSettingsView()
        }
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapCard(_ gestureRecognizer: UITapGestureRecognizer) {
        if let view = gestureRecognizer.view {
            playSound(forCardAt: view.tag)
        }
    }
    
    
    // MARK: - UI
    
    private func addProgressSliderIfNeeded() {
        if !needToShowProgressSlider { return }
        
        progressNavigationController?.progressViewMaxiumumValue = Float(lesson.exercises.count + 2)
        progressNavigationController?.progressViewValue = 1
        progressNavigationController?.addProgressView()
    }
    
    private func removeProgressSliderIfNeeded() {
        if !needToShowProgressSlider { return }
        
        progressNavigationController?.removeProgressView()
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
                view.delegate = self
                if model.hasSound {
                    view.addGestureRecognizer(
                        UITapGestureRecognizer(
                            target: self,
                            action: #selector(didTapCard(_:))))
                }
                contentView.addSubview(view)
                cardViews.append(view)
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
            button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
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
    
    private func adjustScrollContentSize() {
        scrollView.contentSize = CGSize(
            width: scrollView.contentSize.width,
            height: contentView.bounds.height)
    }
    
    private func showPlayerIfNeeded() {
        if isPlayerOnScreen { return }
        
        playerContainerViewYConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func scroll(to cardView: LessonCardView) {
        guard let superview = cardView.superview,
            let index = superview.subviews.index(of: cardView)
            else {
                return
        }
        
        // если есть заголовок до этой карточки, то проскроллить к нему
        var targetView: UIView = cardView
        if index > 0 {
            let prevView = superview.subviews[(index - 1)]
            if prevView is LessonSectionHeaderView || prevView is LessonCardSeparatorView {
                targetView = prevView
            }
        }
        
        let frame = scrollView.convert(targetView.frame, from: superview)
        let frameTopLeft = CGRect(origin: frame.origin, size: scrollView.bounds.size)
        scrollView.scrollRectToVisible(frameTopLeft, animated: true)

    }
        
    
    // MARK: - Sounds
    
    private func playSound(forCardAt index: Int, shouldScrollToPlayingCard: Bool = false) {
        guard index < lesson.cards.count, index >= 0
            else {
                audioPlayer?.currentTime = 0
                playerView.isPlaying = false
                playerView.setCurrentProgress(0)
                currentPlayingCardView?.isPlayingSound = false
                return
        }
        
        let ascending = currentPlayingCardIndex < index
        
        let card = lesson.cards[index]
        
        guard let url = card.soundURL
            else {
                let newIndex = ascending ? (index + 1) : (index - 1)
                playSound(forCardAt: newIndex, shouldScrollToPlayingCard: shouldScrollToPlayingCard)
                return
        }
        
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        
        currentPlayingCardView?.isPlayingSound = false
        currentPlayingCardIndex = index
        currentPlayingCardView?.isPlayingSound = true
        
        if shouldScrollToPlayingCard,
            let cardView = currentPlayingCardView {
            scroll(to: cardView)
        }

        self.audioPlayer = audioPlayer
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        
        playerView.setCurrentProgress(0)
        playerView.soundDuration = audioPlayer.duration
        playerView.hasPreviousSound = hasPreviousSound
        playerView.hasNextSound = hasNextSound
        playerView.isPlaying = true
        showPlayerIfNeeded()
        
        audioPlayer.play()
        
        startTimer()
    }
    
    
    // MARK: - Timer
    
    private func startTimer() {
        stopTimer()
        let timeInterval = playerMode == .normal ? 1 : 0.2
        playingTimer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(playingTimerFired),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(playingTimer!, forMode: RunLoopMode.commonModes)
    }
    
    private func stopTimer() {
        playingTimer?.invalidate()
        playingTimer = nil
    }
    
    @objc private func playingTimerFired() {
        guard let audioPlayer = audioPlayer else { return }
        
        var currentTime = audioPlayer.currentTime
        
        switch playerMode {
        case .normal:
            break
        case .fastForward:
            currentTime += 0.5
            audioPlayer.currentTime = min(currentTime, audioPlayer.duration)
        case .fastBackward:
            currentTime -= 0.5
            audioPlayer.currentTime = max(currentTime, 0)
        }
        
        playerView.setCurrentProgress(currentTime)
    }
    
    
    // MARK: - Segues
    
    private func showExerciseViewControllerWithContainer(at index: Int) {
        guard lesson.exerciseContainers.count > index else {
            progressNavigationController?.progressViewValue =
                progressNavigationController?.progressViewMaxiumumValue ?? 0
            lessonFinished()
            return
        }
        
        let exerciseContainer = lesson.exerciseContainers[index]
        var vc: UIViewController & HasCompletion
        
        switch exerciseContainer.exerciseType {
        case .test:
            let exerciseVC = UIStoryboard.viewController(
                ofType: TestExerciseViewController.self,
                fromStoryboard: "Main")
            exerciseVC.exercise = exerciseContainer.exercise as! TestExercise
            vc = exerciseVC
        case .pronounce:
            let exerciseVC = UIStoryboard.viewController(
                ofType: PronounceExerciseViewController.self,
                fromStoryboard: "Main")
            exerciseVC.exercise = exerciseContainer.exercise as! PronounceExercise
            vc = exerciseVC
        case .reading:
            let exerciseVC = UIStoryboard.viewController(
                ofType: ReadingExerciseViewController.self,
                fromStoryboard: "Main")
            exerciseVC.exercise = exerciseContainer.exercise as! ReadingExercise
            vc = exerciseVC
        case .writingByExample:
            let exerciseVC = UIStoryboard.viewController(
                ofType: WritingByExampleExerciseViewController.self,
                fromStoryboard: "Main")
            exerciseVC.exercise = exerciseContainer.exercise as! WritingByExampleExercise
            vc = exerciseVC
        case .writingByTranscription:
            let exerciseVC = UIStoryboard.viewController(
                ofType: WritingByTranscriptionExerciseViewController.self,
                fromStoryboard: "Main")
            exerciseVC.exercise = exerciseContainer.exercise as! WritingByTranscriptionExercise
            vc = exerciseVC
        }
        
        vc.completion = { [weak self] in
            self?.showExerciseViewControllerWithContainer(at: (index + 1))
        }
        vc.title = "\(title!). Упражнение \(index + 1)"
        navigationController?.pushViewController(vc, animated: true)
        
        progressNavigationController?.progressViewValue = Float(index + 2)
    }
    
    private func popToPreviousScreen() {
        guard let viewControllers = navigationController?.viewControllers else { return }
        
        removeProgressSliderIfNeeded()
        
        for vc in viewControllers {
            if let vc = vc as? BookModuleViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func lessonFinished() {
        AppProgressManager.setItemDone(areAllCardsDone(), for: lesson.path)
        popToPreviousScreen()
    }
    
    
    // MARK: - Helpers
    
    private func cardView(at index: Int) -> LessonCardView? {
        guard index >= 0, index < cardViews.count else { return nil }
        
        return cardViews[index]
    }
    
    private func areAllCardsDone() -> Bool {
        for card in lesson.cards {
            let isDone = AppProgressManager.isItemDone(key: card.path)
            if !isDone { return false }
        }
        
        return true
    }
    
}


extension LessonCardsViewController: LessonCardViewDelegate {
    
    func lessonCardView(_ view: LessonCardView, didPressCheck checked: Bool) {
        guard lesson.cards.count > view.tag else {
            assertionFailure()
            return
        }
        
        let card = lesson.cards[view.tag]
        AppProgressManager.setItemDone(checked, for: card.path)
        
        let isLessonDone = areAllCardsDone() && lesson.exercises.isEmpty
        AppProgressManager.setItemDone(isLessonDone, for: lesson.path)

        if card === lesson.cards.last!, isLessonDone {
            popToPreviousScreen()
        }
    }
    
}


extension LessonCardsViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopTimer()
        playerView.setMaximumProgress()
        playSound(forCardAt: currentPlayingCardIndex + 1)
    }
    
}


extension LessonCardsViewController: SoundPlayerViewDelegate {
    
    func playerDidPressPreviousTrackButton(_ player: SoundPlayerView) {
        playSound(forCardAt: currentPlayingCardIndex - 1, shouldScrollToPlayingCard: true)
    }
    
    func playerDidPressNextTrackButton(_ player: SoundPlayerView) {
        playSound(forCardAt: currentPlayingCardIndex + 1, shouldScrollToPlayingCard: true)
    }
    
    func playerDidBeginFastBackwarding(_ player: SoundPlayerView) {
        playerMode = .fastBackward
        startTimer()
    }
    
    func playerDidEndFastBackwarding(_ player: SoundPlayerView) {
        playerMode = .normal
        startTimer()
    }
    
    func playerDidBeginFastForwarding(_ player: SoundPlayerView) {
        playerMode = .fastForward
        startTimer()
    }
    
    func playerDidEndFastForwarding(_ player: SoundPlayerView) {
        playerMode = .normal
        startTimer()
    }

    func playerDidPressPlayButton(_ player: SoundPlayerView) {
        guard let audioPlayer = audioPlayer else { return }
        
        if audioPlayer.isPlaying {
            stopTimer()
            audioPlayer.pause()
            playerView.isPlaying = false
        } else {
            audioPlayer.play()
            playerView.isPlaying = true
            startTimer()
        }
    }
    
    func playerDidEndDraggingProgressSlider(_ player: SoundPlayerView, value: TimeInterval) {
        audioPlayer?.currentTime = value
    }

}


extension LessonCardsViewController: UINavigationControllerDelegate {
    
    
    
}


extension LessonCardsViewController: HasFontSettingsView { }
