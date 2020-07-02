//
//  PagedTableViewModel.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import Foundation

public protocol YipYipPagedTableViewModel: YipYipTableViewModel {
    
    typealias GetNextPageCompletionHandler = (_ sucess: Bool) -> Void
    
    var allItemsLoaded: Bool { get }
    var hasLoadedItems: Bool { get }
    
    func loadNextPage(_ completionHandler: @escaping GetNextPageCompletionHandler)
    func resetData()
    
    var emptyTitle: String? { get }
    var emptyMessage: String? { get }
    var dataFailedTitle: String? { get }
    var dataFailedMessage: String? { get }
    var dataFailedRetryButtonTitle: String? { get }
}

public extension YipYipPagedTableViewModel {
    
    func resetData() {
    }
    
    var emptyTitle: String? {
        return NSLocalizedString("TableViewNoItemsViewTitle", comment: "")
    }
    
    var emptyMessage: String? {
        return NSLocalizedString("TableViewNoItemsViewMessage", comment: "")
    }
    
    var dataFailedTitle: String? {
        return NSLocalizedString("TableViewDataFailedViewTitle", comment: "")
    }
    
    var dataFailedMessage: String? {
        return NSLocalizedString("TableViewDataFailedViewMessage", comment: "")
    }
    
    var dataFailedRetryButtonTitle: String? {
        return NSLocalizedString("TableViewDataFailedViewRetryButtonTitle", comment: "")
    }
    
}
