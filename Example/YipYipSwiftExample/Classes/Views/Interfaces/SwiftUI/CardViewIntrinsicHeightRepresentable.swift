//
//  CardViewIntrinsicHeightRepresentable.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import SwiftUI
import YipYipSwift

internal struct CardViewIntrinsicHeightRepresentable: YipYipIntrinsicHeightViewRepesentable {
    
    typealias ViewType = CardView
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    private let title: String?
    private let subtitle: String?
    private let maxLines: Int
    private let maxHeight: CGFloat?
    
    // ----------------------------------------------------
    // MARK: - (De)Initializer(s)
    // ----------------------------------------------------
    
    internal init(title: String?, subtitle: String?, maxLines: Int, maxHeight: CGFloat? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.maxLines = maxLines
        self.maxHeight = maxHeight
    }
    
    // ----------------------------------------------------
    // MARK: - View methods
    // ----------------------------------------------------
    
    internal func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.maxHeight = self.maxHeight
        uiView.contentView.title = self.title
        uiView.contentView.subtitle = self.subtitle
        uiView.contentView.maxLines = self.maxLines
    }
    
}
