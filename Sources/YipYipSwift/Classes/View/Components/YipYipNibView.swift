//
//  NibView.swift
//  YipYipSwift
//
//  Created by Rens Wijnmalen on 15/06/2017.
//  Copyright © 2017 YipYip. All rights reserved.
//

import UIKit
import os.log

open class YipYipNibView: UIView {
    
    public var nibView:UIView!
    
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Initializers
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Computed properties
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    open var nibFileName:String? {
        return nil
    }
    
    open var bundle:Bundle {
        return Bundle.main
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Public methods
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------
    // MARK: -- View life cycle
    // -----------------------------------------------------------
    
    open func viewDidLayout(){
        
    }

    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Private methods
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    private func nibSetup() {
        let nibFileName:String = self.nibFileName == nil ? String(describing: type(of: self)) : self.nibFileName!
        if YipYipUtils.view.nibExists(name: nibFileName, bundle: self.bundle) {
            self.nibView = YipYipUtils.view.addViewFromNib(nibName: nibFileName, bundle: self.bundle, toOwner: self)
        } else {
            os_log("Filename \"%{PUBLIC}@\" does not exist", log: OSLog.YipYipNibView, type: .error, nibFileName)
        }
        self.viewDidLayout()
    }
}
