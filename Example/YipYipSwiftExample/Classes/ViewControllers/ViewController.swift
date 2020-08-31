//
//  ViewController.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 15/04/2019.
//  Copyright © 2019 YipYip. All rights reserved.
//

import UIKit
import YipYipSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

