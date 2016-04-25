//
//  RxAVAudioPlayerDelegateProxy.swift
//  LearnRxSwift
//
//  Created by 宋宋 on 16/4/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

class RxAVAudioPlayerDelegateProxy: DelegateProxy, AVAudioPlayerDelegate, DelegateProxyType  {
    
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let audioPlayer = object as! AVAudioPlayer
        return audioPlayer.delegate
    }
    
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let audioPlayer = object as! AVAudioPlayer
        audioPlayer.delegate = delegate as? AVAudioPlayerDelegate
    }
    
}

extension AVAudioPlayer {
    
    var rx_delegate: DelegateProxy {
        return proxyForObject(RxAVAudioPlayerDelegateProxy.self, self)
    }
    
    var rx_audioPlayerDidFinishPlaying: ControlEvent<Bool> {
        let source = rx_delegate.observe(#selector(AVAudioPlayerDelegate.audioPlayerDidFinishPlaying(_:successfully:))).map { a in
            return a[1] as! Bool
        }
        
        return ControlEvent(events: source)
    }
    
    var rx_audioPlayerDecodeErrorDidOccur: ControlEvent<NSError?> {
        let source = rx_delegate.observe(#selector(AVAudioPlayerDelegate.audioPlayerDecodeErrorDidOccur(_:error:))).map { a in
            return a[1] as? NSError
        }
        
        return ControlEvent(events: source)
    }
    
    @available(iOS, introduced=2.2, deprecated=8.0)
    var rx_audioPlayerBeginInterruption: ControlEvent<Void> {
        let source = rx_delegate.observe(#selector(AVAudioPlayerDelegate.audioPlayerBeginInterruption(_:))).map { _ in }
        
        return ControlEvent(events: source)
    }
    
    @available(iOS, introduced=6.0, deprecated=8.0)
    var rx_audioPlayerEndInterruption: ControlEvent<Int> {
        let source = rx_delegate.observe(#selector(AVAudioPlayerDelegate.audioPlayerEndInterruption(_:withOptions:))).map { a in
            return a[1] as! Int
        }
        
        return ControlEvent(events: source)
    }
    
}
