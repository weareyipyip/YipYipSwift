//
//  NibView.swift
//  Commando Training
//
//  Created by Rens Wijnmalen on 15/06/2017.
//  Copyright © 2017 YipYip. All rights reserved.
//

import UIKit

open class NibView: UIView {
    
    var nibView:UIView!
    var nibFileName:String? {
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    func nibSetup() {
        if let nibFileName = self.nibFileName{
            self.nibView = YipYipUtils.view.loadViewFromNib(name: nibFileName, toView: self)
        } else {
            print("NibView: Property \"nibFileName\" must be override")
        }
    }

}
