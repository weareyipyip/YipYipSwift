//
//  YipYipContentSizedTableView.swift
//  YipYipSwift
//
//  Created by Rens Wijnmalen on 03/07/2020.
//

import UIKit

public class YipYipContentSizedTableView: UITableView {

    private var heightConstraint: NSLayoutConstraint?
    
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
            self.setNeedsLayout()
        }
        
    }
    
}
