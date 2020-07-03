//
//  YipYipContentSizedCollectionView.swift
//  YipYipSwift
//
//  Created by Rens Wijnmalen on 03/07/2020.
//

import UIKit

public class YipYipContentSizedCollectionView: UICollectionView {
    
    private var heightConstraint: NSLayoutConstraint?
    
    // TODO: Add width content size support. Never needed so its not implemented for now.
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.isScrollEnabled = false
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var heightDidChange = false
        
        if self.heightConstraint == nil {
            self.heightConstraint = YipYipUtils.constraints.heightConstraint(for: self)
        }
        
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.contentSize.height)
            self.addConstraint(self.heightConstraint!)
            heightDidChange = true
            
        } else {
            if (self.heightConstraint?.constant ?? 0) != self.contentSize.height {
                self.heightConstraint?.constant = self.contentSize.height
                heightDidChange = true
            }
        }
        
        if heightDidChange {
            self.layoutIfNeeded()
        }
        
    }
    
}
