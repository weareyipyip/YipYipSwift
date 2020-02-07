//
//  OSLog+DefaultLog.swift
//  YipYipSwift
//
//  Created by YipYip on 28/01/2019.
//

import Foundation
import os.log

// ----------------------------------------------------
// MARK: - Examples:
// ----------------------------------------------------

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    public static let app = OSLog(subsystem: subsystem, category: "app") // Application layer
    public static let ux = OSLog(subsystem: subsystem, category: "ux") // User experiance layer
    public static let netwerk = OSLog(subsystem: subsystem, category: "netwerk") // Networking layer
    public static let parsing = OSLog(subsystem: subsystem, category: "parsing") // Parsing layer
    public static let database = OSLog(subsystem: subsystem, category: "database") // Database layer
    
    public static let userLoginFlow = OSLog(subsystem: subsystem, category: "userLoginFlow") // User login flow layer (Discuss)
    public static let analytics = OSLog(subsystem: subsystem, category: "analytics") // Analytics layer  (Discuss)
    public static let reviewManager = OSLog(subsystem: subsystem, category: "reviewManager") // AppStoreReviewManager
}
