//
//  ViewModalBase.swift
//  PersonHelp
//
//  Created by Rens Wijnmalen on 06/06/2018.
//  Copyright © 2018 YipYip. All rights reserved.
//

import UIKit

open class YipYipViewModelBase: NSObject {

    open var _loadDataErrorType:ServicesErrorType? = .none
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: Computed properties
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    open var hasLoadingError:Bool{
        return self._loadDataErrorType != nil
    }
}
