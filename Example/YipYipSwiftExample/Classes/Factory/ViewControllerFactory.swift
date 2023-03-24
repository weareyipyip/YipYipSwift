//
//  ViewControllerFactory.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import UIKit

internal class ViewControllerFactory {
    
    // ----------------------------------------------------
    // MARK: - Storyboards
    // ----------------------------------------------------
    
    private static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private static let swiftuiStoryboard = UIStoryboard(name: "SwiftUI", bundle: nil)
    private static let pagedTableViewStoryboard = UIStoryboard(name: "PagedTableView", bundle: nil)
    private static let safeAreaStoryboard = UIStoryboard(name: "SafeAreaLayoutConstraint", bundle: nil)
    
    // ----------------------------------------------------
    // MARK: - ViewControllers
    // ----------------------------------------------------
    
    internal static func pagedTableViewController() -> PagedTableViewViewController {
        let vc = self.pagedTableViewStoryboard.instantiateViewController(withIdentifier: "PagedTableViewViewController") as! PagedTableViewViewController
        return vc
    }
    
    internal static func swiftuiDemoveViewController() -> SwiftUIDemoViewController {
        let vc = self.swiftuiStoryboard.instantiateViewController(withIdentifier: "SwiftUIDemoViewController") as! SwiftUIDemoViewController
        return vc
    }
    
}
