//
//  YipYipIntrinsicWidthContainerView.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import UIKit

public class YipYipIntrinsicWidthContainerView<ContentView: UIView>: YipYipIntrinsicContainerViewBase<ContentView> {
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    public var maxWidth: CGFloat?
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
 
    override public var intrinsicContentSize: CGSize {
        
        // Layout the view to to calculate the right width with the determined height
        self.contentView.layoutIfNeeded()
        
        // Calculate width based on height and layout priorities
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: self.frame.height)
        var contentWidth = self.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .defaultHigh
        ).width
        
        // If a maxWidth has been set, check if the calculated width complies to the set value
        if let maxWidth {
            contentWidth = min(maxWidth, contentWidth)
        }
        
        return CGSize(width: contentWidth, height: self.frame.height)
    }
    
}
