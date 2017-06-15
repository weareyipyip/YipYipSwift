//
//  UIVIew+Storyboard.swift
//  E-Democracy
//
//  Created by Rens Wijnmalen on 07/11/16.
//  Copyright © 2016 YipYip. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func loadViewFromNib(name:String, toView view:UIView)->UIView {
        
        let bundle = Bundle.main
        let views = UINib(nibName: name, bundle: bundle).instantiate(withOwner: self, options: nil) as [AnyObject]
        var returnView = UIView()
        if let view = views[0] as? UIView{
            returnView = view
        } else {
            returnView = UIView()
        }
        
        returnView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(returnView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: [], metrics: nil, views: ["view":returnView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view":returnView]))
        
        return returnView
    }
    
}
