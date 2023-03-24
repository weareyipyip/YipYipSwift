//
//  PagedTableViewViewControllerRepresentable.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import UIKit
import SwiftUI

internal struct PagedTableViewViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PagedTableViewViewController
    
    internal func makeUIViewController(context: Context) -> PagedTableViewViewController {
        return ViewControllerFactory.pagedTableViewController()
    }
    
    internal func updateUIViewController(_ uiViewController: PagedTableViewViewController, context: Context) {
    }
    
}
