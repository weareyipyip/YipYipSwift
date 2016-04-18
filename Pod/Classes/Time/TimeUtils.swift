//
//  TimeUtil.swift
//  Yixow
//
//  Created by Marcel Bloemendaal on 26/05/15.
//  Copyright (c) 2015 YipYip. All rights reserved.
//

import Foundation

public class TimeUtils
{
	private var _cachedDateFormatter:NSDateFormatter?
    
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Properties
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    private var iso8601DateFormatter:NSDateFormatter
    {
        if let dateFormatter = self._cachedDateFormatter
        {
            return dateFormatter
        }
        else
        {
            self._cachedDateFormatter = NSDateFormatter()
            let enUSPOSIXLocale = NSLocale(localeIdentifier:"en_US_POSIX");
            self._cachedDateFormatter!.locale = enUSPOSIXLocale
            self._cachedDateFormatter!.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return self._cachedDateFormatter!
        }
    }
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: - Public methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	public func dateFromISO8601TimeString(string:String)->NSDate?
	{
		return self.iso8601DateFormatter.dateFromString(string)
	}
}
