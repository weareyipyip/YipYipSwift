//
//  NetwerkError.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 16/04/2019.
//

import Foundation

public enum NetwerkError: Error{
    case noInternet
    case cannotParseData
    case requestNotValid
    case contentNotFound
    case unauthorized
    case forbidden
    case unknown
}
