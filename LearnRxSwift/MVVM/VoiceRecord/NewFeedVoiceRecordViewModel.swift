//
//  NewFeedVoiceRecordViewModel.swift
//  Yep
//
//  Created by 宋宋 on 16/4/6.
//  Copyright © 2016年 Catch Inc. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import AVFoundation

class NewFeedVoiceRecordViewModel: NSObject {
    
    enum State {
        case Default
         /// 录音中
        case Recording
         /// 结束录音
        case FinishRecord
    }
     /// 当前录音状态
    let state = Variable(State.Default)
     /// 采样值
    let sampleValue = Variable<CGFloat>(0)
     /// 音频是否在播放
    let audioPlaying = Variable(false)
     /// 音频播放的时间
    let audioPlayedDuration = Variable<NSTimeInterval>(0)
    
    private var playbackTimer: NSTimer?
    
    private var voiceFileURL: NSURL?
    private var audioPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?
    
    private let disposeBag = DisposeBag()
    
    init(input: (voiceRecordTrigger: Driver<Void>, resetTrigger: Driver<Void>, playOrPauseAudio: Driver<Void>)) {
        super.init()
        input.voiceRecordTrigger.withLatestFrom(state.asDriver())
            .driveNext { [unowned self] state in
                switch state {
                case .Recording where YepAudioService.sharedManager.audioRecorder?.currentTime < YepConfig.AudioRecord.shortestDuration:
                    //                    YepAlert.alertSorry(message: NSLocalizedString("Voice recording time is too short!", comment: ""), inViewController: self, withDismissAction: { [weak self] in
                    //                        self?.state = .Default
                    //                        })
                    fallthrough
                case .Recording:
                    YepAudioService.sharedManager.endRecord()
                case .Default, .FinishRecord:
                    let audioFileName = NSUUID().UUIDString
                    if let fileURL = NSFileManager.yepMessageAudioURLWithName(audioFileName) {
                        self.voiceFileURL = fileURL
                        YepAudioService.sharedManager.shouldIgnoreStart = false
                        YepAudioService.sharedManager.beginRecordWithFileURL(fileURL, audioRecorderDelegate: self)
                        self.state.value = .Recording
                    }

                }
        }.addDisposableTo(disposeBag)
        
        
        input.resetTrigger.map { _ in State.Default }.asObservable().bindTo(state).addDisposableTo(disposeBag)
        
        input.playOrPauseAudio.map { [unowned self] in self.voiceFileURL }.filterNil()
            .driveNext { voiceFileURL in
                if let audioPlayer = self.audioPlayer {
                    switch audioPlayer.playing {
                    case true:
                        audioPlayer.pause()
                        self.audioPlaying.value = false
                        self.playbackTimer?.invalidate()
                    case false:
                        audioPlayer.currentTime = self.audioPlayedDuration.value
                        audioPlayer.play()
                        self.audioPlaying.value = true
                        
                        self.playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(NewFeedVoiceRecordViewModel.updateAudioPlaybackProgress(_:)), userInfo: nil, repeats: true)
                    }
                } else {
                    if AVAudioSession.sharedInstance().category == AVAudioSessionCategoryRecord {
                        do {
                            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                        } catch let error {
                            print("playVoice setCategory failed: \(error)")
                            return
                        }
                    }
                    
                    do {
                        let audioPlayer = try AVAudioPlayer(contentsOfURL: voiceFileURL)
                        
                        self.audioPlayer = audioPlayer // hold it
                        
                        audioPlayer.delegate = self
                        audioPlayer.prepareToPlay()
                        
                        if audioPlayer.play() {
                            print("do play voice")
                            
                            self.audioPlaying.value = true
                            
                            self.playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(NewFeedVoiceRecordViewModel.updateAudioPlaybackProgress(_:)), userInfo: nil, repeats: true)
                        }
                        
                    } catch let error {
                        print("play voice error: \(error)")
                    }
                }
        }.addDisposableTo(disposeBag)
        
        state.asDriver().driveNext { state in
            switch state {
            case .Default:
                self.sampleValue.value = 0
                self.audioPlayer?.stop()
                self.audioPlayer = nil
                self.audioPlaying.value = false
                
                self.playbackTimer?.invalidate()
                self.audioPlayedDuration.value = 0
                
            case .Recording:
                
                self.displayLink = CADisplayLink(target: self, selector: #selector(NewFeedVoiceRecordViewModel.checkVoiceRecordValue(_:)))
                self.displayLink?.frameInterval = 6 // 频率为每秒 10 次
                self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
                
                break
            case .FinishRecord:
                break
            }
        }.addDisposableTo(disposeBag)
        
    }
    
    @objc private func checkVoiceRecordValue(sender: AnyObject) {
        
        guard let audioRecorder = YepAudioService.sharedManager.audioRecorder where audioRecorder.recording else { return }
        
        audioRecorder.updateMeters()
        let normalizedValue = pow(10, audioRecorder.averagePowerForChannel(0)/40)
        let value = CGFloat(normalizedValue)
        
        sampleValue.value = value

        
    }
    
    @objc private func updateAudioPlaybackProgress(timer: NSTimer) {
        
        if let audioPlayer = audioPlayer {
            let currentTime = audioPlayer.currentTime
            audioPlayedDuration.value = currentTime
        }
    }
    
}

extension NewFeedVoiceRecordViewModel: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        state.value = .FinishRecord
        
        print("audioRecorderDidFinishRecording: \(flag)")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        
        state.value = .Default
        
        print("audioRecorderEncodeErrorDidOccur: \(error)")
    }
}

// MARK: - AVAudioPlayerDelegate

extension NewFeedVoiceRecordViewModel: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        audioPlaying.value = false
        audioPlayedDuration.value = 0
        state.value = .FinishRecord
        
        print("audioPlayerDidFinishPlaying: \(flag)")
        
        YepAudioService.sharedManager.resetToDefault()
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        
        print("audioPlayerDecodeErrorDidOccur: \(error)")
        
        YepAudioService.sharedManager.resetToDefault()
    }
}