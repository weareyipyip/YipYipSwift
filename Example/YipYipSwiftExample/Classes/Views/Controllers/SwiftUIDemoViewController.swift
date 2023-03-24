//
//  SwiftUIDemoViewController.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import UIKit

internal class SwiftUIDemoViewController: UIViewController {
    
    @IBOutlet private weak var buttonViewHostingView: ButtonViewHostingView!
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonViewHostingView.buttonConfiguration = ButtonView.Configuration(
            action: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            label: "SwiftUI Button - Close view"
        )
        
        self.buttonViewHostingView.placeContentView()
    }
    
}
