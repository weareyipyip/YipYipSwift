//
//  TestDataViewModel.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import Foundation
import YipYipSwift

public class TestDataViewModel {
    
    public var items: [String]?
    private var debugItemsToAppend = [
        "Republic of Ireland",
        "United Arab Emirates",
        "North Korea",
        "Lithuania",
        "Saint Pierre and Miquelon",
        "Reunion",
        "Bermuda",
        "Niue",
        "Netherlands",
        "Central African Republic",
        "Martinique",
        "Trinidad and Tobago",
        "United Kingdom",
        "New Caledonia",
        "Norfolk Island",
        "East Timor",
        "Isle of Man",
        "Israel",
        "Russia",
        "Northern Mariana Islands",
    ];
    
}

extension TestDataViewModel: YipYipPagedTableViewModel {
    
    // ----------------------------------------------------
    // MARK: - PagedTableViewModel
    // ----------------------------------------------------
    
    public var allItemsLoaded: Bool {
        return (self.items?.count ?? 0) > 150
    }
    
    public var hasLoadedItems: Bool {
        return self.items != nil
    }
    
    public func loadNextPage(_ completionHandler: @escaping GetNextPageCompletionHandler) {
        
//        // Show empty
//        self.items = []
//        completionHandler(true)
        
//        // Show error
//        completionHandler(false)
        
        // Show data
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            timer.invalidate()
            if self.items != nil {
                self.items!.append(contentsOf: self.debugItemsToAppend)
            } else {
                self.items = self.debugItemsToAppend
            }
            DispatchQueue.main.async {
                completionHandler(true)
            }
        }
    }
    
    public func numberOfItemsForSection(_ section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    public func itemForIndexPath(_ indexPath: IndexPath) -> Any {
        return self.items![indexPath.row]
    }
    
}
