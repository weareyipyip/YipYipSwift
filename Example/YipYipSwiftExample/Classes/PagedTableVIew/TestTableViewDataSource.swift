//
//  TestTableViewDataSource.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 02/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import UIKit

public class TestTableViewDataSource: NSObject, UITableViewDataSource {
    
    public let viewModel: TestDataViewModel
    
    public init(viewModel: TestDataViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsForSection(section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TestCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TestCell")
        }
        cell!.textLabel?.text = (self.viewModel.itemForIndexPath(indexPath) as! String)
        return cell!
    }
    
    
}
