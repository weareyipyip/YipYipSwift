//
//  TestGetResonse.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 16/04/2019.
//  Copyright © 2019 YipYip. All rights reserved.
//

import Foundation

class TestGetResponse: Codable{
    
    let url: String
    
    private enum CodingKeys : String, CodingKey {
        case url
    }
    
}
