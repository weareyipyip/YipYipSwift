//
//  YipYipIntrinsicWidthViewRepresentable.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import SwiftUI

@available(iOS 13.0, *)
public protocol YipYipIntrinsicWidthViewRepesentable: UIViewRepresentable where UIViewType == YipYipIntrinsicWidthContainerView<ViewType> {
    associatedtype ViewType: UIView
}

@available(iOS 13.0, *)
extension YipYipIntrinsicWidthViewRepesentable {
    
    // ----------------------------------------------------
    // MARK: - View methods
    // ----------------------------------------------------
    
    public func makeUIView(context: Context) -> UIViewType {
        return YipYipIntrinsicWidthContainerView(contentView: ViewType())
    }
    
    @available(iOS 16.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        
        // This method needs to be implemented to support the YipYipIntrinsicWidthContainerView on iOS 16
        // In case of the intrinsic width container view pick the height of the proprosal and the width of the view
        return CGSize(width: uiView.intrinsicContentSize.width, height: proposal.height ?? 0)
    }
    
}
