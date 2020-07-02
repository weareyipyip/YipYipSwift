
//
//  JSONUtils.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 21/10/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation
import os.log

open class JSONUtils
{
	open func dictionaryFromData(_ data:Data)->[String:AnyObject]?
	{
		var dictionary:[String:AnyObject]?
		
		do
		{
			dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
		}
		catch let error as NSError
		{
            os_log("Error parsing dictionary from data: %{PUBLIC}@", log: OSLog.JSONUtils, type: .error, error.localizedDescription)
		}
		catch
		{
            os_log("Error parsing dictionary from data: Unknown error", log: OSLog.JSONUtils, type: .error)
		}
		
		return dictionary
	}
	
	open func dataFromDictionary(_ dictionary:Any)->Data?
	{
		var data:Data?
		
		do
		{
			data = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
		}
		catch let error as NSError
		{
            os_log("Error parsing data from dictionary: %{PUBLIC}@", log: OSLog.JSONUtils, type: .error, error.localizedDescription)
		}
		catch
		{
			os_log("Error parsing data from dictionary: Unknown error", log: OSLog.JSONUtils, type: .error)
		}
		
		return data
	}
	
	open func readDictionaryFromJSONFileAtPath(_ path:String)->[String:AnyObject]?
	{
		if let data = try? Data(contentsOf: URL(fileURLWithPath: path))
		{
			return self.dictionaryFromData(data)
		}
		return nil
	}
	
	open func writeDictionaryToJSONFile(dictionary:Any, destinationPath:String)->Bool
	{
		if let data = self.dataFromDictionary(dictionary)
		{
			return ((try? data.write(to: URL(fileURLWithPath: destinationPath), options: [.atomic])) != nil)
		}
		return false
	}
}
