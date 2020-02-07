//
//  FileUtil.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 10/06/15.
//  Copyright (c) 2015 YipYip. All rights reserved.
//

import Foundation

open class FileUtils
{
	open func getDocumentsDirectoryPath()->String
	{
		let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		return paths[0]
	}
    
    open func deleteDirectory(_ directoryPath:String)
    {
        if let url = URL(string: directoryPath)
        {
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: 0), errorHandler: nil)
            while let file = enumerator?.nextObject() as? String
            {
                try! fileManager.removeItem(at: url.appendingPathComponent(file))
            }
            try! fileManager.removeItem(at: url)
        }
    }
}
