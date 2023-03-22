//
//  YipYipHostingController.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
public protocol YipYipHostingController where Self: UIViewController {
    associatedtype ContentView: View
    var hostingController: UIHostingController<ContentView>? { get set }
    func createContentView() -> ContentView
    func placeContentView()
}

@available(iOS 13.0, *)
extension YipYipHostingController {
    
    public func placeContentView() {
        
        // Remove the hostingController that may have been setup before
        if let hostingController = self.hostingController {
            hostingController.willMove(toParent: nil)
            hostingController.removeFromParent()
            hostingController.view.removeFromSuperview()
        }
        
        // Setup the new HostingController
        let hostingController = UIHostingController(
            rootView: self.createContentView()
        )
        self.hostingController = hostingController
        
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
}
