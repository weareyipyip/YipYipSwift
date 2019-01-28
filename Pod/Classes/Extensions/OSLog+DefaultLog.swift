//
//  OSLog+DefaultLog.swift
//  YipYipSwift
//
//  Created by Rens Wijnmalen on 28/01/2019.
//

import Foundation
import os.log

// ----------------------------------------------------
// MARK: - Examples:
// ----------------------------------------------------

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let app = OSLog(subsystem: subsystem, category: "app") // Application layer
    static let ux = OSLog(subsystem: subsystem, category: "ux") // User experiance layer
    static let netwerk = OSLog(subsystem: subsystem, category: "netwerk") // Networking layer
    static let parsing = OSLog(subsystem: subsystem, category: "parsing") // Parsing layer
    static let database = OSLog(subsystem: subsystem, category: "database") // Database layer
    
    static let userLoginFlow = OSLog(subsystem: subsystem, category: "userLoginFlow") // User login flow layer (Discuss)
    static let analytics = OSLog(subsystem: subsystem, category: "analytics") // Analytics layer  (Discuss)
}
