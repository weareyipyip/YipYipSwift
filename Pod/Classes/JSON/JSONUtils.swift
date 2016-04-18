
//
//  JSONUtils.swift
//  Commando Training
//
//  Created by Marcel Bloemendaal on 21/10/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation

public class JSONUtils
{
	public func dictionaryFromData(data:NSData)->[String:AnyObject]?
	{
		var dictionary:[String:AnyObject]?
		
		do
		{
			dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String : AnyObject]
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
	
	public func dataFromDictionary(dictionary:[String:AnyObject])->NSData?
	{
		var data:NSData?
		
		do
		{
			data = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions(rawValue: 0))
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
	
	public func readDictionaryFromJSONFileAtPath(path:String)->[String:AnyObject]?
	{
		if let data = NSData(contentsOfFile: path)
		{
			return self.dictionaryFromData(data)
		}
		return nil
	}
	
	public func writeDictionaryToJSONFile(dictionary dictionary:[String:AnyObject], destinationPath:String)->Bool
	{
		if let data = self.dataFromDictionary(dictionary)
		{
			return data.writeToFile(destinationPath, atomically: true)
		}
		return false
	}
}