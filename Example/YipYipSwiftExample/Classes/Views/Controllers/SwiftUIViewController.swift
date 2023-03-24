//
//  SwiftUIViewController.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import UIKit
import SwiftUI
import YipYipSwift

internal class SwiftUIViewController: UIViewController, YipYipHostingController {

    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    internal var hostingController: YipYipEmbeddedHostingController<SwiftUIMain>?
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
                
        self.placeContentView()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Hosting controller methods
    // ----------------------------------------------------
    
    internal func createContentView() -> SwiftUIMain {
        return SwiftUIMain(delegate: self)
    }
    
}

extension SwiftUIViewController: SwiftUIMainDelegate {
    
    internal func userDidTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    internal func userDidTapDemoButton() {
        let vc = ViewControllerFactory.swiftuiDemoveViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
