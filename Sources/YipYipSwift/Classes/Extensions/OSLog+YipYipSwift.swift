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
    
    public static let YipYipNibView = OSLog(subsystem: subsystem, category: "YipYipNibView")
    public static let JSONUtils = OSLog(subsystem: subsystem, category: "JSONUtils")
    public static let AppStoreReviewManager = OSLog(subsystem: subsystem, category: "AppStoreReviewManager")
}
