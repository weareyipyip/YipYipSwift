//
//  NibView.swift
//  Commando Training
//
//  Created by Rens Wijnmalen on 15/06/2017.
//  Copyright © 2017 YipYip. All rights reserved.
//

import UIKit

open class YipYipNibView: UIView {
    
    public var nibView:UIView!
    open var nibFileName:String? {
        return nil
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    fileprivate func nibSetup() {
        if let nibFileName = self.nibFileName{
            self.nibView = self.loadViewFromNib(name: nibFileName, toView: self)
        } else {
            print("NibView: Property \"nibFileName\" must be override")
        }
    }
    
    fileprivate func loadViewFromNib(name:String, toView view:UIView)->UIView {
        
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
