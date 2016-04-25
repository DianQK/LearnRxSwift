//
//  YepHelper.swift
//  LearnRxSwift
//
//  Created by 宋宋 on 16/4/25.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import AVFoundation
import UIKit

extension UIColor {
    class func yepTintColor() -> UIColor {
        return UIColor(red: 50/255.0, green: 167/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class func yepBorderColor() -> UIColor {
        return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }
}

class YepConfig {
    class func audioSampleWidth() -> CGFloat {
        return 2
    }
    
    class func audioSampleGap() -> CGFloat {
        return 1
    }
    
    struct AudioRecord {
        static let shortestDuration: NSTimeInterval = 1.0
        static let longestDuration: NSTimeInterval = 60
    }
}

enum FileExtension: String {
    case JPEG = "jpg"
    case MP4 = "mp4"
    case M4A = "m4a"
    
    var mimeType: String {
        switch self {
        case .JPEG:
            return "image/jpeg"
        case .MP4:
            return "video/mp4"
        case .M4A:
            return "audio/m4a"
        }
    }
}

extension NSFileManager {
    class func yepMessageAudioURLWithName(name: String) -> NSURL? {
        
        if let messageCachesURL = yepMessageCachesURL() {
            return messageCachesURL.URLByAppendingPathComponent("\(name).\(FileExtension.M4A.rawValue)")
        }
        
        return nil
    }
    
    class func yepMessageCachesURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let messageCachesURL = yepCachesURL().URLByAppendingPathComponent("message_caches", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(messageCachesURL, withIntermediateDirectories: true, attributes: nil)
            return messageCachesURL
        } catch _ {
        }
        
        return nil
    }
    
    class func yepCachesURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
}