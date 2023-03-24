//
//  DataStatusTableView.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import UIKit
import YipYipSwift

public class CustomTableView: UITableView, YipYipActivityStatusTableView {
    
    private var _activityIndicatorView: UIActivityIndicatorView?
    public var activityIndicatorView: UIView {
        if let aiv = self._activityIndicatorView {
            return aiv
        }
        let aiv = self.setupActivityIndicator()
        self._activityIndicatorView = aiv
        return aiv
    }
    
    private var _emptyDataView: YipYipEmptyTableViewDataView?
    public var emptyDataView: YipYipEmptyTableViewDataView {
        if let edv = self._emptyDataView {
            return edv
        }
        let edv = self.setupEmptyDataView()
        self._emptyDataView = edv
        return edv
    }
    
    // ----------------------------------------------------
    // MARK: - Setup methods
    // ----------------------------------------------------
    
    private func setupActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        self.superview?.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        return activityIndicatorView
    }
    
    private func setupEmptyDataView() -> YipYipEmptyTableViewDataView {
        let emptyView = EmptyDataView()
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            emptyView.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor),
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        return emptyView
    }
    
    // ----------------------------------------------------
    // MARK: - Public methods
    // ----------------------------------------------------
    
    public func startLoading() {
        if (self.dataSource?.tableView(self, numberOfRowsInSection: 0) ?? 0) == 0 {
            (self.activityIndicatorView as? UIActivityIndicatorView)?.startAnimating()
        }
    }
    
    public func stopLoading() {
        (self.activityIndicatorView as? UIActivityIndicatorView)?.stopAnimating()
    }
    
    public func showEmptyDataView(title: String? = nil, message: String? = nil, actionButtonTitle: String? = nil, delegate: EmptyTableViewDataViewDelegate? = nil) {
        self.emptyDataView.title = title
        self.emptyDataView.message = message
        self.emptyDataView.actionButtonTitle = actionButtonTitle
        self.emptyDataView.delegate = delegate
        self.emptyDataView.isHidden = false
    }
    
    public func hideEmptyDataView() {
        self.emptyDataView.isHidden = true
    }

}
