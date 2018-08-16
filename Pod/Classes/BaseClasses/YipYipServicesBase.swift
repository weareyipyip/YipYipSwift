//
//  ServicesBase.swift
//  PersonHelp
//
//  Created by Rens Wijnmalen on 11/05/2018.
//  Copyright © 2018 YipYip. All rights reserved.
//

import Foundation

public enum ServicesErrorType:Int{
    case noInternet
    case cannotParseData
    case contentNotFound
    case requestNotValid
    case toManyRequests
    case unknown
}

open class YipYipServicesBase {
    
    private static let _queryParameterAllowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?")
    
    private let _operationQueue = OperationQueue()
    open var showDebugErrors = true
    
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
    
    open func executeURLRequest(path:String, method:String, queryVariables:String? = nil, jsonVariables:[String:AnyObject]? = nil, extraHeaderFields:[String:String]? = nil, completion:@escaping (Int, Data?, ServicesErrorType?) -> Void) {
        
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
            
            if method != "GET" && jsonVariables != nil {
                if let jsonData = YipYipUtils.json.dataFromDictionary(jsonVariables!) {
                    request.httpBody = jsonData
                }
            }
            
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
    
    open func addCustomPropertiesToRequest(path: String, method: String, request: inout URLRequest){
        
    }
    
    open func executeURLRequest(urlRequest:URLRequest, completion:@escaping (Int, Data?, ServicesErrorType?) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            let (statusCode, result, errorType) = self.processAPIResponse(data: data, response: response, error: error)
            completion(statusCode, result, errorType)
        })
        task.resume()
    }
    
    // -----------------------------------------------------------
    // MARK: -- Response processing
    // -----------------------------------------------------------
    
    open func processAPIResponse(data:Data?, response:URLResponse?, error:Error?)->(statusCode:Int, result:Data?, errorType:ServicesErrorType?) {
        
        var statusCode = 0
        var errorType:ServicesErrorType?
        if let error = error {
            errorType = self.errorTypeForError(error: error)
            if self.showDebugErrors{
                print(">>>>> Debug >>>>> Error reason: \(self.errorReasonTextForError(error: error))")
            }
        } else {
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
        }
        return (statusCode, data, errorType)
    }
    
    // -----------------------------------------------------------
    // MARK: -- Decoding data
    // -----------------------------------------------------------
    
    open func decodeData<T: Decodable>(_ data:Data, forType type:T.Type)->Any?{
        
        var decoder = JSONDecoder()
        
        self.addDateEncodingToDecoder(decoder: &decoder)
        self.addCustomPropertiesToDecoder(decoder: &decoder)
        
        var returnData:Any?
        do {
            returnData = try decoder.decode(type, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            if self.showDebugErrors{
                print(">>>>> Debug >>>>> Missing key: \(key)")
                print(">>>>> Debug >>>>> Debug description: \(context.debugDescription)")
                
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                print(">>>>> Debug >>>>> JSON: /n\(debugString ?? "not found")")
            }
        } catch DecodingError.valueNotFound(let type, let context) {
            if self.showDebugErrors{
                print(">>>>> Debug >>>>> Missing value: \(type)")
                print(">>>>> Debug >>>>> Debug description: \(context.debugDescription)")
                
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                print(">>>>> Debug >>>>> JSON: /n\(debugString ?? "not found")")
            }
        } catch {
            if self.showDebugErrors{
                print(">>>>> Debug >>>>> Unknown error: \(error.localizedDescription)")
                
                let debugString = String(data: data, encoding: String.Encoding.utf8)
                print(">>>>> Debug >>>>> JSON: /n\(debugString ?? "not found")")
            }
        }
        return returnData
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
    
    open func errorTypeForError(error:Error)->ServicesErrorType {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternet
            default:
                return .unknown
            }
        }
        return .unknown
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
