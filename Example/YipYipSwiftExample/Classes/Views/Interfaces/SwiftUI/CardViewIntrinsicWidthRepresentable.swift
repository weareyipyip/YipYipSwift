//
//  CardViewIntrinsicWidthRepresentable.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 23/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import SwiftUI
import YipYipSwift

internal struct CardViewIntrinsicWidthRepresentable: YipYipIntrinsicWidthViewRepesentable {
    
    typealias ViewType = CardView
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    private let title: String?
    private let subtitle: String?
    private let maxLines: Int
    private let maxWidth: CGFloat?
    
    // ----------------------------------------------------
    // MARK: - (De)Initializer(s)
    // ----------------------------------------------------
    
    internal init(title: String?, subtitle: String?, maxLines: Int, maxWidth: CGFloat? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.maxLines = maxLines
        self.maxWidth = maxWidth
    }
    
    // ----------------------------------------------------
    // MARK: - View methods
    // ----------------------------------------------------
    
    internal func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.maxWidth = self.maxWidth
        uiView.contentView.title = self.title
        uiView.contentView.subtitle = self.subtitle
        uiView.contentView.maxLines = self.maxLines
    }
    
}
