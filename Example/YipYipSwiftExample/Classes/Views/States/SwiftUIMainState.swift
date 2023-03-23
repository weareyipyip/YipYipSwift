//
//  SwiftUIMainState.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import Foundation

internal class SwiftUIMainState: ObservableObject {
    
    @Published internal var showPagedTableView: Bool = false
    @Published internal var showLongTextUIKitView: Bool = false
    @Published internal var enableMultilineUIKitView: Bool = false
    
    // ----------------------------------------------------
    // MARK: - User interaction methods
    // ----------------------------------------------------
    
    internal func userDidTapPagedTableViewButton() {
        self.showPagedTableView = true
    }
    
}
