//
//  NewFeedVoiceRecordViewController.swift
//  Yep
//
//  Created by nixzhu on 15/11/25.
//  Copyright © 2015年 Catch Inc. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import RxOptional
import NSObject_Rx

class NewFeedVoiceRecordViewController: UIViewController {

    @IBOutlet private weak var nextButton: UIBarButtonItem!

    @IBOutlet private weak var voiceRecordSampleView: VoiceRecordSampleView!
    @IBOutlet private weak var voiceIndicatorImageView: UIImageView!
    @IBOutlet private weak var voiceIndicatorImageViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var timeLabel: UILabel!
    
    @IBOutlet private weak var voiceRecordButton: RecordButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    
    private var viewModel: NewFeedVoiceRecordViewModel!

    deinit {
//        displayLink?.invalidate()
//        playbackTimer?.invalidate()
        print("deinit NewFeedVoiceRecord", terminator: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Voice"

        nextButton.title = "Next"

        // 如果进来前有声音在播放，令其停止
        if let audioPlayer = YepAudioService.sharedManager.audioPlayer where audioPlayer.playing {
            audioPlayer.pause()
        }
        
        viewModel = NewFeedVoiceRecordViewModel(input: (
            voiceRecordTrigger: voiceRecordButton.rx_tap.asDriver(),
            resetTrigger: resetButton.rx_tap.asDriver(),
            playOrPauseAudio: playButton.rx_tap.asDriver()))
        
        
        viewModel.state.asDriver().driveNext { state in
            switch state {
            case .Default:
                self.nextButton.enabled = false
                self.voiceIndicatorImageView.alpha = 0
                
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
                    
                    self?.voiceRecordButton.alpha = 1
                    self?.voiceRecordButton.appearance = .Default
                    
                    self?.playButton.alpha = 0
                    self?.resetButton.alpha = 0
                    
                    }, completion: { _ in })
                
                self.voiceRecordSampleView.reset()
                
                self.voiceIndicatorImageViewCenterXConstraint.constant = 0
                
            case .Recording:
                
                self.nextButton.enabled = false
                
                self.voiceIndicatorImageView.alpha = 0
                
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
                    
                    self?.voiceRecordButton.alpha = 1
                    self?.voiceRecordButton.appearance = .Recording
                    
                    self?.playButton.alpha = 0
                    self?.resetButton.alpha = 0
                    
                    }, completion: { _ in })

            case .FinishRecord:
                self.nextButton.enabled = true
                
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
                    
                    self?.voiceRecordButton.alpha = 0
                    self?.playButton.alpha = 1
                    self?.resetButton.alpha = 1
                    
                    }, completion: { _ in })
                
                let fullWidth = self.voiceRecordSampleView.bounds.width
                
                if !self.voiceRecordSampleView.sampleValues.isEmpty {
                    let firstIndexPath = NSIndexPath(forItem: 0, inSection: 0)
                    self.voiceRecordSampleView.sampleCollectionView.scrollToItemAtIndexPath(firstIndexPath, atScrollPosition: .Left, animated: true)
                }
                
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
                    self?.voiceIndicatorImageView.alpha = 1
                    
                    }, completion: { _ in
                        
                        UIView.animateWithDuration(0.75, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] in
                            self?.voiceIndicatorImageViewCenterXConstraint.constant = -fullWidth * 0.5 + 2
                            self?.view.layoutIfNeeded()
                            }, completion: { _ in })
                })
                
//                self.displayLink?.invalidate()
            }
        }.addDisposableTo(rx_disposeBag)
        
        viewModel.sampleValue.asDriver().scan(0, accumulator: { $0.0 + 1 }).driveNext { [unowned self] in
            let count = $0
            let frequency = 10
            let minutes = count / frequency / 60
            let seconds = count / frequency - minutes * 60
            let subSeconds = count - seconds * frequency - minutes * 60 * frequency
            
            self.timeLabel.text = String(format: "%02d:%02d.%d", minutes, seconds, subSeconds)
        }.addDisposableTo(rx_disposeBag)
        
        viewModel.audioPlaying.asDriver().driveNext {
            switch $0 {
            case true:  self.playButton.setImage(UIImage(named: "button_voice_pause"), forState: .Normal)
            case false: self.playButton.setImage(UIImage(named: "button_voice_play"), forState: .Normal)
            }
        }.addDisposableTo(rx_disposeBag)
        
        viewModel.sampleValue.asDriver().skip(1).drive(voiceRecordSampleView.rx_appendSampleValue).addDisposableTo(rx_disposeBag)
        
        typealias Value = (newValue: NSTimeInterval, oldValue: NSTimeInterval)
        
        viewModel.audioPlayedDuration.asDriver().distinctUntilChanged()
            .scan(Value(newValue: 0, oldValue: 0)) { Value(newValue: $1, oldValue: $0.newValue) }.skip(1)
            .driveNext { duration in
            let sampleStep: CGFloat = (4 + 2)
            let fullWidth = self.voiceRecordSampleView.bounds.width
            
//            let fullOffsetX = CGFloat(self.viewModel.sampleValues.count) * sampleStep
            
            let currentOffsetX = CGFloat(duration.newValue) * (10 * sampleStep)
            
            // 0.5 用于回去
            let duration: NSTimeInterval = duration.newValue > duration.oldValue ? 0.02 : 0.5
            
//            if fullOffsetX > fullWidth {
                
                if currentOffsetX <= fullWidth * 0.5 {
                    UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: { [weak self] in
                        self?.voiceIndicatorImageViewCenterXConstraint.constant = -fullWidth * 0.5 + 2 + currentOffsetX
                        self?.view.layoutIfNeeded()
                        }, completion: { _ in })
                    
                } else {
                    self.voiceRecordSampleView.sampleCollectionView.setContentOffset(CGPoint(x: currentOffsetX - fullWidth * 0.5 , y: 0), animated: false)
                }
                
//            } else {
//                UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: { [weak self] in
//                    self?.voiceIndicatorImageViewCenterXConstraint.constant = -fullWidth * 0.5 + 2 + currentOffsetX
//                    self?.view.layoutIfNeeded()
//                    }, completion: { _ in })
//            }
        }.addDisposableTo(rx_disposeBag)
        
        
    }
    
    // MARK: - Actions
    
    @IBAction private func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: { [weak self] in
            
//            self?.displayLink?.invalidate()
//            self?.playbackTimer?.invalidate()
            
            YepAudioService.sharedManager.endRecord()
            
//            if let voiceFileURL = self?.voiceFileURL {
//                do {
//                    try NSFileManager.defaultManager().removeItemAtURL(voiceFileURL)
//                } catch let error {
//                    println("delete voiceFileURL error: \(error)")
//                }
//            }
            })
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        if let feedVoiceBox = sender as? Box<FeedVoice> where segue.identifier == "showNewFeed" {
//            let vc = segue.destinationViewController as! NewFeedViewController
            
//            vc.attachment = .Voice(feedVoiceBox.value)
            
//            vc.preparedSkill = preparedSkill
            
//            vc.beforeUploadingFeedAction = beforeUploadingFeedAction
//            vc.afterCreatedFeedAction = afterCreatedFeedAction
//            vc.getFeedsViewController = getFeedsViewController
//        }

    }
}