//
//  ButtonViewHostingView.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import UIKit
import SwiftUI
import YipYipSwift

internal class ButtonViewHostingView: UIView, YipYipHostingView {
    internal var hostingController: UIHostingController<ButtonView>?
    internal var buttonConfiguration: ButtonView.Configuration!
    
    internal func createContentView() -> ButtonView {
        guard let buttonConfiguration else {
            fatalError("Button configuration is nil before place")
        }
        return ButtonView(configuration: buttonConfiguration)
    }
}
