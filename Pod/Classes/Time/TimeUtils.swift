//
//  TimeUtil.swift
//  Yixow
//
//  Created by Marcel Bloemendaal on 26/05/15.
//  Copyright (c) 2015 YipYip. All rights reserved.
//

import Foundation

open class TimeUtils
{
	private var _cachedDateFormatter:DateFormatter?
    
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Properties
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    private var iso8601DateFormatter:DateFormatter
    {
        if let dateFormatter = self._cachedDateFormatter
        {
            return dateFormatter
        }
        else
        {
            self._cachedDateFormatter = DateFormatter()
            let enUSPOSIXLocale = Locale(identifier:"en_US_POSIX");
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
	
	open func dateFromISO8601TimeString(_ string:String)->Date?
	{
		return self.iso8601DateFormatter.date(from: string)
	}
    
    open func iso8601TimeStringFromDate(_ date:Date)->String?
    {
        return self.iso8601DateFormatter.string(from: date)
    }
}
