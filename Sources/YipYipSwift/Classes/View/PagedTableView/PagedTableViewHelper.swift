//
//  PagedTableViewHelper.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import UIKit

public class YipYipPagedTableViewHelper {
    
    private let loadMargin: Int
    private var tableView: YipYipDataStatusTableView
    private var viewModel: YipYipPagedTableViewModel
    private var isLoadingNextPage: Bool = false
    
    // ----------------------------------------------------
    // MARK: - Initializers
    // ----------------------------------------------------
    
    public init(_ tableView: YipYipDataStatusTableView, viewModel: YipYipPagedTableViewModel, autoLoadFirstItems: Bool = true, loadMargin: Int = 5) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.loadMargin = loadMargin
        
        if autoLoadFirstItems {
            self.scrollViewDidScroll(self.tableView)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Public methods
    // ----------------------------------------------------
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isLoadingNextPage, !self.viewModel.allItemsLoaded {
            if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows, let lastVisibleIndexPaths = visibleIndexPaths.last {
                let numberOfItems = self.viewModel.numberOfItemsForSection(0)
                if (lastVisibleIndexPaths.row >= (numberOfItems - self.loadMargin)) {
                    self.loadNextPage()
                }
            }
            else {
                self.loadNextPage()
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Private methods
    // ----------------------------------------------------
    
    private func loadNextPage() {
        self.isLoadingNextPage = true
        if !self.viewModel.hasLoadedItems {
            self.hideEmptyView()
            self.tableView.startLoading()
        }
        self.viewModel.loadNextPage { (success) in
            self.tableView.stopLoading()
            self.tableView.reloadData()
            self.isLoadingNextPage = false
            self.tableView.isHidden = false

            if success {
                if self.viewModel.hasLoadedItems, self.viewModel.numberOfItemsForSection(0) == 0 {
                    self.showNoItemsView()
                } else {
                    self.hideEmptyView()
                }
            } else {
                if !self.viewModel.hasLoadedItems {
                    self.showDataNotLoadedView()
                } else {
                    self.hideEmptyView()
                }
            }
        }
    }
    
    public func showDataNotLoadedView() {
        self.tableView.isUserInteractionEnabled = false
        self.tableView.showEmptyDataView(title: self.viewModel.dataFailedTitle,
                                         message: self.viewModel.dataFailedMessage,
                                         actionButtonTitle: self.viewModel.dataFailedRetryButtonTitle,
                                         delegate: self)
    }
    
    public func showNoItemsView() {
        self.tableView.isUserInteractionEnabled = false
        self.tableView.showEmptyDataView(title: self.viewModel.emptyTitle,
                                         message: self.viewModel.emptyMessage,
                                         actionButtonTitle: nil,
                                         delegate: nil)
    }
    
    public func hideEmptyView() {
        self.tableView.isUserInteractionEnabled = true
        self.tableView.hideEmptyDataView()
    }
    
    public func startLoading() {
        self.tableView.hideEmptyDataView()
        self.tableView.isHidden = true
        self.tableView.startLoading()
    }
    
}

extension YipYipPagedTableViewHelper: EmptyTableViewDataViewDelegate {
    public func userDidTapActionButton(in emptyDataView: YipYipEmptyTableViewDataView) {
        self.scrollViewDidScroll(self.tableView)
    }
}
