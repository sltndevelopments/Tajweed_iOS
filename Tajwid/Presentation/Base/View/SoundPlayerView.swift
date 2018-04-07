//
//  SoundPlayerView.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 31/03/2018.
//  Copyright © 2018 teorius. All rights reserved.
//

import UIKit


protocol SoundPlayerViewDelegate: class {
    
    func playerDidPressPreviousTrackButton(_ player: SoundPlayerView)
    
    func playerDidPressNextTrackButton(_ player: SoundPlayerView)

    func playerDidBeginFastBackwarding(_ player: SoundPlayerView)

    func playerDidEndFastBackwarding(_ player: SoundPlayerView)
    
    func playerDidBeginFastForwarding(_ player: SoundPlayerView)
    
    func playerDidEndFastForwarding(_ player: SoundPlayerView)

    func playerDidPressPlayButton(_ player: SoundPlayerView)
    
    func playerDidStartDraggingProgressSlider(_ player: SoundPlayerView)

    func playerDidEndDraggingProgressSlider(_ player: SoundPlayerView, value: TimeInterval)
    
}


extension SoundPlayerViewDelegate {
    
    func playerDidStartDraggingProgressSlider(_ player: SoundPlayerView) { }
    
}


class SoundPlayerView: UIView {

    // MARK: - Outlets
    
    @IBOutlet weak var progressSlider: TrackProgressSlider!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var overallTimeLabel: UILabel!
    
    @IBOutlet weak var previousTrackButton: StateChangesObservableButton!
    
    @IBOutlet weak var nextTrackButton: StateChangesObservableButton!
    
    @IBOutlet weak var backwardsButton: StateChangesObservableButton!
    
    @IBOutlet weak var forwardButton: StateChangesObservableButton!
    
    @IBOutlet weak var playButton: StateChangesObservableButton!
    
    @IBOutlet var buttons: [StateChangesObservableButton]!
    
    
    // MARK: - Public properties
    
    weak var delegate: SoundPlayerViewDelegate?
    
    var soundDurationMultiplier = 1.0
    
    var soundDuration = TimeInterval(1) {
        didSet {
            progressSlider.maximumValue = Float(soundDuration * soundDurationMultiplier)
            overallTimeLabel.text = timeStringFromInterval(soundDuration)
        }
    }
    
    var isPlaying = false {
        didSet {
            let image = isPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
            playButton.setImage(image, for: .normal)
        }
    }
    
    var hasNextSound = true {
        didSet {
            nextTrackButton.isEnabled = hasNextSound
        }
    }
    
    var hasPreviousSound = true {
        didSet {
            previousTrackButton.isEnabled = hasPreviousSound
        }
    }
    
    var ignoresProgressSetWhileDragging = true
    
    
    // MARK: - Private properties
    
    private var isDraggingSlider = false
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m:ss"
        return dateFormatter
    }()
    
    
    // MARK: - Public methods
    
    func setCurrentProgress(_ progress: TimeInterval) {
        if ignoresProgressSetWhileDragging && isDraggingSlider { return }
        
        progressSlider.value = Float(progress * soundDurationMultiplier)
        currentTimeLabel.text = timeStringFromInterval(progress)
    }
    
    func setMaximumProgress() {
        if ignoresProgressSetWhileDragging && isDraggingSlider { return }
        progressSlider.value = progressSlider.maximumValue
    }
    
    
    // MARK: - Private methods
    
    private func timeStringFromInterval(_ interval: TimeInterval) -> String? {
        var components = DateComponents()
        components.minute = Int(interval) / 60
        components.second = Int(interval) % 60
        guard let date = Calendar.current.date(from: components) else { return nil }
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Override
    
    override func awakeFromNib() {
        progressSlider.value = 0
        progressSlider.addTarget(self, action: #selector(sliderTouched), for: .allTouchEvents)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        for button in buttons {
            if button === backwardsButton {
                button.highlitedStateChanged = { [weak self] isHighlited in
                    guard let `self` = self else { return }
                    
                    button.alpha = isHighlited ? 0.5 : 1
                    
                    if isHighlited {
                        self.delegate?.playerDidBeginFastBackwarding(self)
                    } else {
                        self.delegate?.playerDidEndFastBackwarding(self)
                    }
                }
            } else if button === forwardButton {
                button.highlitedStateChanged = { [weak self] isHighlited in
                    guard let `self` = self else { return }
                    
                    button.alpha = isHighlited ? 0.5 : 1
                    
                    if isHighlited {
                        self.delegate?.playerDidBeginFastForwarding(self)
                    } else {
                        self.delegate?.playerDidEndFastForwarding(self)
                    }
                }
            } else {
                button.highlitedStateChanged = { isHighlited in
                    button.alpha = isHighlited ? 0.5 : 1
                }
            }
        }
        
        previousTrackButton.setImage(#imageLiteral(resourceName: "prev-track-disabled"), for: .disabled)
        nextTrackButton.setImage(#imageLiteral(resourceName: "next-track-disabled"), for: .disabled)
    }
    
    
    // MARK: - Actions
    
    @objc private func sliderTouched() {
        if isDraggingSlider == progressSlider.isHighlighted {
            return
        }
        
        isDraggingSlider = progressSlider.isHighlighted
        
        if isDraggingSlider {
            delegate?.playerDidStartDraggingProgressSlider(self)
        } else {
            delegate?.playerDidEndDraggingProgressSlider(
                self,
                value: TimeInterval(progressSlider.value / Float(soundDurationMultiplier)))
        }
    }
    
    @objc private func sliderValueChanged() {
        currentTimeLabel.text = timeStringFromInterval(
            TimeInterval(progressSlider.value / Float(soundDurationMultiplier)))
    }
    
    @IBAction func previousTrackButtonPressed() {
        delegate?.playerDidPressPreviousTrackButton(self)
    }
    
    @IBAction func nextTrackButtonPressed() {
        delegate?.playerDidPressNextTrackButton(self)
    }
    
    @IBAction func playButtonPressed() {
        delegate?.playerDidPressPlayButton(self)
    }
    
}
