//
//  EmptyDataView.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import UIKit

public protocol EmptyTableViewDataViewDelegate: AnyObject {
    
    func userDidTapActionButton(in emptyTableViewDataView: YipYipEmptyTableViewDataView)
    
}

public protocol YipYipEmptyTableViewDataView: UIView {
    
    var title: String? { set get }
    var message: String? { set get }
    var actionButtonTitle: String? { set get }
    var delegate: EmptyTableViewDataViewDelegate? { set get }
    
}
