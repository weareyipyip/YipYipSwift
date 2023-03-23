//
//  YipYipHostingView.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
public protocol YipYipHostingView where Self: UIView {
    associatedtype ContentView: View
    var hostingController: YipYipEmbeddedHostingController<ContentView>? { get set }
    func createContentView() -> ContentView
    func placeContentView()
}

@available(iOS 13.0, *)
extension YipYipHostingView {
    
    public func placeContentView() {
        
        // Remove the hostingController that may have been setup before
        if let hostingController = self.hostingController {
            hostingController.view.removeFromSuperview()
        }
        
        // Setup the new HostingController
        let hostingController = YipYipEmbeddedHostingController(rootView: self.createContentView())
        
        self.hostingController = hostingController
        self.addSubview(hostingController.view)
        
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
