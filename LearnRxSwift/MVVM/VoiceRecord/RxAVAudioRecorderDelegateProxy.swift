//
//  RxAVAudioRecorderDelegateProxy.swift
//  Yep
//
//  Created by 宋宋 on 16/4/7.
//  Copyright © 2016年 Catch Inc. All rights reserved.
//

import RxSwift
import RxCocoa
import AVFoundation

class RxAVAudioRecorderDelegateProxy: DelegateProxy, AVAudioRecorderDelegate, DelegateProxyType  {

    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let audioRecorder = object as! AVAudioRecorder
        return audioRecorder.delegate
    }

    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let audioRecorder = object as! AVAudioRecorder
        audioRecorder.delegate = delegate as? AVAudioRecorderDelegate
    }

}

extension AVAudioRecorder {
    
    var rx_delegate: DelegateProxy {
        return proxyForObject(RxAVAudioRecorderDelegateProxy.self, self)
    }
    
    var rx_audioRecorderDidFinishRecording: ControlEvent<Bool> {
        let source = rx_delegate.observe(#selector(AVAudioRecorderDelegate.audioRecorderDidFinishRecording(_:successfully:)))
            .map { a in
            return a[1] as! Bool
        }
        
        return ControlEvent(events: source)
    }
    
    var rx_audioRecorderEncodeErrorDidOccur: ControlEvent<NSError?> {
        let source = rx_delegate.observe(#selector(AVAudioRecorderDelegate.audioRecorderEncodeErrorDidOccur(_:error:)))
            .map { a in
            return a[1] as? NSError
        }
        
        return ControlEvent(events: source)
    }
    
    @available(iOS, introduced=2.2, deprecated=8.0)
    var rx_audioRecorderBeginInterruption: ControlEvent<Void> {
        let source = rx_delegate.observe(#selector(AVAudioRecorderDelegate.audioRecorderBeginInterruption(_:))).map { _ in }
        
        return ControlEvent(events: source)
    }
    
    @available(iOS, introduced=6.0, deprecated=8.0)
    var rx_audioRecorderEndInterruption: ControlEvent<Int> {
        let source = rx_delegate.observe(#selector(AVAudioRecorderDelegate.audioRecorderEndInterruption(_:withOptions:)))
            .map { a in
            return a[1] as! Int
        }
        
        return ControlEvent(events: source)
    }
}
