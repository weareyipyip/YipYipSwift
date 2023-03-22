//
//  YipYipIntrinsicHeightViewRepresentable.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import SwiftUI

@available(iOS 13.0, *)
public protocol YipYipIntrinsicHeightViewRepesentable: UIViewRepresentable where UIViewType == YipYipIntrinsicHeightContainerView<ViewType> {
    associatedtype ViewType: UIView
}

@available(iOS 13.0, *)
extension YipYipIntrinsicHeightViewRepesentable {
    
    // ----------------------------------------------------
    // MARK: - View methods
    // ----------------------------------------------------
    
    public func makeUIView(context: Context) -> UIViewType {
        return YipYipIntrinsicHeightContainerView(contentView: ViewType())
    }
    
    @available(iOS 16.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        
        // This method needs to be implemented to support the YipYipIntrinsicHeightContainerView on iOS 16
        // In case of the intrinsic height container view pick the width of the proprosal and the height of the view
        return CGSize(width: proposal.width ?? 0, height: uiView.intrinsicContentSize.height)
    }
    
}
