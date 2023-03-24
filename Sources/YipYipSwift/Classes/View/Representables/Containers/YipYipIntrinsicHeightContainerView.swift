//
//  YipYipIntrinsicHeightContainerView.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import UIKit

public class YipYipIntrinsicHeightContainerView<ContentView: UIView>: YipYipIntrinsicContainerViewBase<ContentView> {
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    public var maxHeight: CGFloat?
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    override public var intrinsicContentSize: CGSize {
        
        // Layout the view to to calculate the right height with the determined width
        self.contentView.layoutIfNeeded()
        
        // Calculate height based on width and layout priorities
        let targetSize = CGSize(width: self.frame.width, height: UIView.layoutFittingCompressedSize.height)
        var contentHeight = self.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        // If a maxHeight has been set, check if the calculated height complies to the set value
        if let maxHeight {
            contentHeight = min(maxHeight, contentHeight)
        }
        
        return CGSize(width: self.frame.width, height: contentHeight)
    }
    
}
