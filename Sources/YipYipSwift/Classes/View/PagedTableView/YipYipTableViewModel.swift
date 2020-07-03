//
//  TableViewModel.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import Foundation

public protocol YipYipTableViewModel {
    
    var numberOfSections: Int { get }
    
    func numberOfItemsForSection(_ section: Int) -> Int
    func titleForHeaderInSection(_ section: Int) -> String?
    func titleForFooterInSection(_ section: Int) -> String?
    func itemForIndexPath(_ indexPath: IndexPath) -> Any
    
}

public extension YipYipTableViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func titleForHeaderInSection(_ section: Int) -> String? {
        return nil
    }
    
    func titleForFooterInSection(_ section: Int) -> String? {
        return nil
    }
    
}
