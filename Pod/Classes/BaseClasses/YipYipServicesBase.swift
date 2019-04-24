//
//  ServicesBase.swift
//  PersonHelp
//
//  Created by Rens Wijnmalen on 11/05/2018.
//  Copyright © 2018 YipYip. All rights reserved.
//

import Foundation
import os.log

public enum NetwerkError: Error{
    case noInternet
    case cannotParseData
    case requestNotValid
    case contentNotFound
    case unauthorized
    case forbidden
    case unknown
}


open class YipYipServicesBase {
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    private static let _queryParameterAllowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?")
    
    private let _operationQueue = OperationQueue()
    open var showDebugErrors = true
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    open var defaultDateFormatterDateFormat:String{
        return "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Initializers
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    public init() {
    }
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Private methods
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------
    // -- API calls
    // -----------------------------------------------------------
    
    open func executeURLRequest(path:String, method:String, queryVariables:String? = nil, jsonVariables:[String:AnyObject]? = nil, extraHeaderFields:[String:String]? = nil, completion:@escaping (Int, Result<Data, NetwerkError>) -> Void) {
        
        var fullPath = path
        if method == "GET" {
            if queryVariables != nil {
                fullPath += "?\(queryVariables!)"
            }
        }
        fullPath = fullPath.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if let url = URL(string: fullPath)
        {
            var request = URLRequest(url: url)
            
            // Default configuration
            self.addDefaultRequestHeadersForMethod(method, request: &request)
            
            // Configuration set in the method call
            if extraHeaderFields != nil {
                for (name, value) in extraHeaderFields! {
                    request.addValue(value, forHTTPHeaderField: name)
                }
            }
            
            // Parse json variables to the http body for the request
            self.addHttpBodyForMethod(method, request: &request, jsonVariables: jsonVariables)
            
            request.httpMethod = method
            
            self.addCustomPropertiesToRequest(path: path, method: method, request: &request)
            self.executeURLRequest(urlRequest: request, completion: completion)
        }
    }
    
    open func addDefaultRequestHeadersForMethod(_ method: String, request: inout URLRequest){
        if method == "POST"{
            request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        }
    }
    
    open func addHttpBodyForMethod(_ method: String, request: inout URLRequest, jsonVariables: [String:AnyObject]?){
        
        // By default we will add the json as raw data.
        if method != "GET", let jsonVariables = jsonVariables {
            if let jsonData = YipYipUtils.json.dataFromDictionary(jsonVariables) {
                request.httpBody = jsonData
            }
        }
    }
    
    open func addCustomPropertiesToRequest(path: String, method: String, request: inout URLRequest){
        
    }
    
    open func executeURLRequest(urlRequest:URLRequest, completion:@escaping (Int, Result<Data, NetwerkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            let (statusCode, result) = self.processAPIResponse(data: data, response: response, error: error)
            completion(statusCode, result)
        })
        task.resume()
    }
    
    // -----------------------------------------------------------
    // MARK: -- Response processing
    // -----------------------------------------------------------
    
    open func processAPIResponse(data:Data?, response:URLResponse?, error:Error?)->(statusCode:Int, Result<Data, NetwerkError>) {
        
        var statusCode = 0
        var result:Result<Data, NetwerkError>?
        if let error = error {
            result = self.resultForError(error: error)
            os_log("Process API Response >> Response error: %{PUBLIC}@", log: OSLog.netwerk, type: .error, self.errorReasonTextForError(error: error))
        } else {
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                result = self.resultForStatusCode(statusCode: statusCode)
            }
        }
        
        if let data = data, result == nil{
            return (statusCode, .success(data))
        }
        else if let result = result{
            return (statusCode, result)
        }
        else {
            return (statusCode, .failure(.unknown))
        }
    }
    
    // -----------------------------------------------------------
    // MARK: -- Decoding data
    // -----------------------------------------------------------
    
    open func decodeData<T: Decodable>(_ data:Data, forType type:T.Type) throws -> Any{
        
        var decoder = JSONDecoder()
        
        self.addDateEncodingToDecoder(decoder: &decoder)
        self.addCustomPropertiesToDecoder(decoder: &decoder)
        
        do {
            return try decoder.decode(type, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            os_log("Decode Data >> Missing key: %{PUBLIC}@, with description: %{PUBLIC}@", log: OSLog.parsing, type: .error, key.debugDescription, context.debugDescription)
            if self.showDebugErrors{
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                os_log("Decode Data >> Failed parsed JSON: %{PUBLIC}@", log: OSLog.parsing, type: .debug, debugString ?? "JSON not found")
            }
            throw DecodingError.keyNotFound(key, context)
            
        } catch DecodingError.valueNotFound(let type, let context) {
            os_log("Decode Data: Missing value: %{PUBLIC}@, with description: %{PUBLIC}@", log: OSLog.parsing, type: .error, "\(type)", context.debugDescription)
            if self.showDebugErrors{
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                os_log("Decode Data >> Failed parsed JSON: %{PUBLIC}@", log: OSLog.parsing, type: .debug, debugString ?? "JSON not found")
            }
            throw DecodingError.valueNotFound(type, context)
            
        } catch DecodingError.typeMismatch(let type, let context) {
            os_log("Decode Data: Type mismatch: %{PUBLIC}@, with description: %{PUBLIC}@", log: OSLog.parsing, type: .error, "\(type)", context.debugDescription)
            if self.showDebugErrors{
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                os_log("Decode Data >> Failed parsed JSON: %{PUBLIC}@", log: OSLog.parsing, type: .debug, debugString ?? "JSON not found")
            }
            throw DecodingError.typeMismatch(type, context)
            
        } catch DecodingError.dataCorrupted(let context){
            os_log("Decode Data: Data corrupted: %{PUBLIC}@", log: OSLog.parsing, type: .error, context.debugDescription)
            if self.showDebugErrors{
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                os_log("Decode Data >> Failed parsed JSON: %{PUBLIC}@", log: OSLog.parsing, type: .debug, debugString ?? "JSON not found")
            }
            throw DecodingError.dataCorrupted(context)
            
        } catch let error {
            os_log("Decode Data: Unknown error: %{PUBLIC}@", log: OSLog.parsing, type: .error, error.localizedDescription)
            if self.showDebugErrors{
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                os_log("Decode Data >> Failed parsed JSON: %{PUBLIC}@", log: OSLog.parsing, type: .debug, debugString ?? "JSON not found")
            }
            throw error
            
        }
    }
    
    open func addDateEncodingToDecoder(decoder: inout JSONDecoder){
        if #available(iOS 10.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = self.defaultDateFormatterDateFormat
            decoder.dateDecodingStrategy = .formatted(formatter)
        }
    }
    
    open func addCustomPropertiesToDecoder(decoder: inout JSONDecoder){
    }
    
    // -----------------------------------------------------------
    // MARK: -- Error processing
    // -----------------------------------------------------------
    
    open func resultForError(error:Error) -> Result<Data, NetwerkError> {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .failure(.noInternet)
            default:
                return .failure(.unknown)
            }
        }
        return .failure(.unknown)
    }
    
    open func resultForStatusCode(statusCode:Int) -> Result<Data, NetwerkError>? {
        switch statusCode{
        case 200..<300:
            return nil
        case 400:
            return .failure(.requestNotValid)
        case 401:
            return .failure(.unauthorized)
        case 403:
            return .failure(.forbidden)
        case 404:
            return .failure(.contentNotFound)
        default:
            return .failure(.unknown)
        }
    }
    
    open func errorReasonTextForError(error:Error)->String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .badURL:
                return NSLocalizedString("Onjuiste URL", comment: "Services: error feedback")
                
            case .timedOut:
                return NSLocalizedString("Verzoek time out", comment: "Services: generic error feedback")
                
            case .unsupportedURL:
                return NSLocalizedString("URL niet ondersteund", comment: "Services: generic error feedback")
                
            case .cannotFindHost:
                return NSLocalizedString("Host onvindbaar", comment: "Services: generic error feedback")
                
            case .cannotConnectToHost:
                return NSLocalizedString("Geen verbinding met host", comment: "Services: generic error feedback")
                
            case .networkConnectionLost:
                return NSLocalizedString("Verbinding verbroken", comment: "Services: generic error feedback")
                
            case .dnsLookupFailed:
                return NSLocalizedString("DNS lookup mislukt", comment: "Services: generic error feedback")
                
            case .httpTooManyRedirects:
                return NSLocalizedString("Te veel redirects", comment: "Services: generic error feedback")
                
            case .resourceUnavailable:
                return NSLocalizedString("Service niet beschikbaar", comment: "Services: generic error feedback")
                
            case .notConnectedToInternet:
                return NSLocalizedString("Geen internet", comment: "Services: generic error feedback")
                
            case .redirectToNonExistentLocation:
                return NSLocalizedString("Redirect locatie onbekend", comment: "Services: generic error feedback")
                
            case .badServerResponse:
                return NSLocalizedString("Onjuiste server respons", comment: "Services: generic error feedback")
                
            case .userCancelledAuthentication:
                return NSLocalizedString("Authenticatie onderbroken", comment: "Services: generic error feedback")
                
            case .userAuthenticationRequired:
                return NSLocalizedString("Authenticatie vereist", comment: "Services: generic error feedback")
                
            case .zeroByteResource:
                return NSLocalizedString("URL met leeg bestand", comment: "Services: generic error feedback")
                
            case .cannotDecodeRawData:
                fallthrough
            case .cannotDecodeContentData:
                fallthrough
            case .cannotParseResponse:
                return NSLocalizedString("Server respons kon niet worden gedecodeerd", comment: "Services: generic error feedback")
                
            default:
                return NSLocalizedString("Er is een onbekende fout opgetreden", comment: "Services: generic error feedback")
            }
        } else {
            return NSLocalizedString("Er is een onbekende fout opgetreden", comment: "Services: generic error feedback")
        }
    }
    
    open func errorReasonTextFor(httpStatusCode:Int)->String {
        switch httpStatusCode {
            
        case 400:
            return NSLocalizedString("Onjuist verzoek", comment: "Services: generic error feedback")
            
        case 401:
            return NSLocalizedString("Niet geauthorizeerd", comment: "Services: generic error feedback")
            
        case 403:
            return NSLocalizedString("Niet toegestaan", comment: "Services: generic error feedback")
            
        case 404:
            return NSLocalizedString("Inhoud niet gevonden", comment: "Services: generic error feedback")
            
        case 408:
            return NSLocalizedString("Verzoek time out", comment: "Services: generic error feedback")
            
        case 409:
            return NSLocalizedString("Conflict", comment: "Services: generic error feedback")
            
        case 500:
            return NSLocalizedString("Server fout", comment: "Services: generic error feedback")
            
        default:
            return NSLocalizedString("Onbekende fout", comment: "Services: generic error feedback")
        }
    }
    
    // -----------------------------------------------------------
    // MARK: -- Sanitizing strings
    // -----------------------------------------------------------
    
    private func safeQueryParameter(parameter:String)->String {
        return parameter.addingPercentEncoding(withAllowedCharacters: YipYipServicesBase._queryParameterAllowedCharacterSet)!
    }
}
