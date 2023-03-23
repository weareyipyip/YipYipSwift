//
//  PagedTableViewViewController.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import UIKit
import YipYipSwift

public class PagedTableViewViewController: UIViewController {

    @IBOutlet weak var contentTableView: CustomTableView!
    
    private let viewModel = TestDataViewModel()
    private var dataSource: TestTableViewDataSource!
    private var tableViewHelper: YipYipPagedTableViewHelper?
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = TestTableViewDataSource(viewModel: self.viewModel)
        self.contentTableView.dataSource = dataSource
        self.contentTableView.delegate = self
        
        self.tableViewHelper = YipYipPagedTableViewHelper(self.contentTableView, viewModel: self.viewModel, autoLoadFirstItems: true, loadMargin: 10);
    }

}

extension PagedTableViewViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableViewHelper?.scrollViewDidScroll(scrollView)
    }
}

extension PagedTableViewViewController: UITableViewDelegate {
    
}
