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
    open var bundle:Bundle {
        return Bundle.main
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
        let className = String(describing: type(of: self))
        if let nibFileName = self.nibFileName{
            if self.nibExist(name: nibFileName){
                self.nibView = self.loadViewFromNib(name: nibFileName, toView: self)
            } else {
                print("NibView: File does nog exist")
            }
        }
        else if self.nibExist(name: className){
            self.nibView = self.loadViewFromNib(name: className, toView: self)
        }
        else {
            print("NibView: Property \"nibFileName\" must be override")
        }
    }
    
    fileprivate func nibExist(name:String)->Bool{
        if let _ = self.bundle.path(forResource: name, ofType: "nib"){
            return true
        }
        return false
    }
    
    fileprivate func loadViewFromNib(name:String, toView view:UIView)->UIView {
        
        let views = UINib(nibName: name, bundle: self.bundle).instantiate(withOwner: self, options: nil) as [AnyObject]
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
