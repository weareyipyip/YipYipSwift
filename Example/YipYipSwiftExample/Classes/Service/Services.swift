//
//  Service.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 15/04/2019.
//  Copyright © 2019 YipYip. All rights reserved.
//

import Foundation
import YipYipSwift

class Services: YipYipServicesBase{
    
    //Test api call from: https://resttesttest.com
    func testGetApiCall(completion:@escaping ((Result<TestGetResponse, NetwerkError>)->())) {
        self.executeURLRequest(path: "https://httpbin.org/get", method: "GET") { (statusCode, result) in
            do {
                let data = try result.get()
                if let testGetResponse = try? self.decodeData(data, forType: TestGetResponse.self) as? TestGetResponse{
                    completion(.success(testGetResponse))
                } else {
                    completion(.failure(.cannotParseData))
                }
            } catch let error as NetwerkError {
                completion(.failure(error.self))
            } catch {
                completion(.failure(.unknown))
            }
        }
        
    }
    
}
