
//
//  JSONUtils.swift
//  Commando Training
//
//  Created by Marcel Bloemendaal on 21/10/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation

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
			print(error.localizedDescription)
		}
		catch
		{
			print("Failed to parse json")
		}
		
		return dictionary
	}
	
	open func dataFromDictionary(_ dictionary:[String:AnyObject])->Data?
	{
		var data:Data?
		
		do
		{
			data = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
		}
		catch let error as NSError
		{
			print(error.description)
		}
		catch
		{
			
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
	
	open func writeDictionaryToJSONFile(dictionary:[String:AnyObject], destinationPath:String)->Bool
	{
		if let data = self.dataFromDictionary(dictionary)
		{
			return ((try? data.write(to: URL(fileURLWithPath: destinationPath), options: [.atomic])) != nil)
		}
		return false
	}
}
