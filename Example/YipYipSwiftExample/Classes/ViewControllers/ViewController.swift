//
//  ViewController.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 15/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import YipYipSwift

class ViewController: YipYipViewControllerBase {

    let services = Services()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.services.testGetApiCall { (result) in
            
            print("Return from api call: \(result)")
            
            do{
                let response = try result.get()
                 print("Url: \(response.url)")
            }
            catch let error{
                print(error)
            }
            
        }
        
    }


}

