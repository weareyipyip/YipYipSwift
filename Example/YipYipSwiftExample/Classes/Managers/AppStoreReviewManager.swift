//
//  AppStoreReviewManager.swift
//  Cyclemasters
//
//  Created by Rens Wijnmalen on 01/07/2019.
//  Copyright © 2019 YipYip. All rights reserved.
//

import Foundation
import StoreKit
import os.log

open class AppStoreReviewManager {
    
    public static var minimumReviewWorthyActionCount = 3
    public static var appStoreUrlPath:String = "" // example: https://apps.apple.com/app/{id}
    
    static let reviewWorthyActionCount = "reviewWorthyActionCount"
    static let lastReviewRequestAppVersion = "lastReviewRequestAppVersion"
    
    // ----------------------------------------------------
    // MARK: - Request for review methods
    // ----------------------------------------------------
    
    static func requestReviewIfAppropriate() {
        
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        // Update action count
        var actionCount = defaults.integer(forKey: AppStoreReviewManager.reviewWorthyActionCount)
        actionCount += 1
        defaults.set(actionCount, forKey: AppStoreReviewManager.reviewWorthyActionCount)
        
        guard actionCount >= self.minimumReviewWorthyActionCount else {
            return
        }
        
        // Getting current and last app version
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: AppStoreReviewManager.lastReviewRequestAppVersion)
        
        // Check if the version is changed
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        // Ask for review
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            os_log("SKStoreReviewController requestReview is not available in iOS versions below 10.3", log: OSLog.reviewManager, type: .debug)
        }
        
        // Reset action count and set current app version
        defaults.set(0, forKey: AppStoreReviewManager.reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: AppStoreReviewManager.lastReviewRequestAppVersion)
    }
    
    static func forceRequestReview() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            os_log("SKStoreReviewController requestReview is not available in iOS versions below 10.3", log: OSLog.reviewManager, type: .debug)
        }
        
    }
    
    // ----------------------------------------------------
    // MARK: - Write review methods
    // ----------------------------------------------------
    
    static func writeReview(){
        
        guard let appStoreUrl = URL(string: self.appStoreUrlPath) else {
            if self.appStoreUrlPath == ""{
                os_log("You have to configure the appStoreUrlPath for the AppStoreReviewManager. Add this line to your AppDelegate class AppStoreReviewManager.appStoreUrlPath = \"{appstore url}\".", log: OSLog.reviewManager, type: .debug)
            } else {
                os_log("The appStoreUrlPath you configured is not a valid URL", log: OSLog.reviewManager, type: .debug)
            }
            return
        }
        
        var components = URLComponents(url: appStoreUrl, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
        
    }
    
}
