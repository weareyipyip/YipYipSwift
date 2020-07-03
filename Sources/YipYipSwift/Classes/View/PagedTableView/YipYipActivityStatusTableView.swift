//
//  DataTableView.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import UIKit

public protocol YipYipActivityStatusTableView: UITableView {
    
    var activityIndicatorView: UIView { get }
    var emptyDataView: YipYipEmptyTableViewDataView { get }
    
    func startLoading()
    func stopLoading()
    
    func showEmptyDataView(title: String?, message: String?, actionButtonTitle: String?, delegate: EmptyTableViewDataViewDelegate?)
    func hideEmptyDataView()
    
}
