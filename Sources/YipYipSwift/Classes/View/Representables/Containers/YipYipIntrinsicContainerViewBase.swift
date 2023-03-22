//
//  YipYipIntrinsicContainerViewBase.swift
//  Pods-YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//

import UIKit

open class YipYipIntrinsicContainerViewBase<ContentView: UIView>: UIView {
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    public private(set) var contentView: ContentView
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    override open var intrinsicContentSize: CGSize {
        fatalError("Property 'intrinsicContentSize', must be overriden by subclass of 'YipYipIntrinsicContainerViewBase'!")
    }
    
    // ----------------------------------------------------
    // MARK: - (De)Initializer(s)
    // ----------------------------------------------------
    
    public init(contentView: ContentView) {
        
        // Store content view for later use
        self.contentView = contentView
        
        super.init(frame: .zero)
        
        // Add contentView as subview and setup constraints
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            // Due to layout issues we need to define the bottom and trailing with a lower priority to prevent errors
            self.constraintTo(
                childAnchor: contentView.bottomAnchor,
                parentAnchor: self.bottomAnchor,
                priority: .defaultHigh
            ),
            self.constraintTo(
                childAnchor: contentView.trailingAnchor,
                parentAnchor: self.trailingAnchor,
                priority: .defaultHigh
            ),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("'init(coder:)' has not been implemented!")
    }
    
    // ----------------------------------------------------
    // MARK: - Helper methods
    // ----------------------------------------------------
    
    private func constraintTo<T: AnyObject>(
        childAnchor: NSLayoutAnchor<T>,
        parentAnchor: NSLayoutAnchor<T>,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        let constraint = childAnchor.constraint(equalTo: parentAnchor)
        constraint.priority = priority
        return constraint
    }
    
}
