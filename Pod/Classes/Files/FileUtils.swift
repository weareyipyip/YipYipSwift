//
//  FileUtil.swift
//  Yixow
//
//  Created by Marcel Bloemendaal on 10/06/15.
//  Copyright (c) 2015 YipYip. All rights reserved.
//

import Foundation

public class FileUtils
{
	public func getDocumentsDirectoryPath()->String
	{
		let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
		return paths[0]
	}
    
    public func deleteDirectory(directoryPath:String)
    {
        if let url = NSURL(string: directoryPath)
        {
            let fileManager = NSFileManager.defaultManager()
            let enumerator = fileManager.enumeratorAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions(rawValue: 0), errorHandler: nil)
            while let file = enumerator?.nextObject() as? String
            {
                try! fileManager.removeItemAtURL(url.URLByAppendingPathComponent(file))
            }
            try! fileManager.removeItemAtURL(url)
        }
    }
}