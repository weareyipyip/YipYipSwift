//
//  SafeAreaLayoutConstraintViewController.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 03/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import UIKit

public class SafeAreaLayoutConstraintViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func userDidTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
