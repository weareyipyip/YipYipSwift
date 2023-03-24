//
//  YipYipEmbeddedHostingController.swift
//  YipYipSwift
//
//  Created by Lars Moesman on 23/03/2023.
//

import SwiftUI

@available(iOS 13.0, *)
public class YipYipEmbeddedHostingController<ContentView: View>: UIHostingController<ContentView> {
    
    // Prevents the UIHostingController from taking over the control over the navigation controller
    override public var navigationController: UINavigationController? {
        return nil
    }
    
}
