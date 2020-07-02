//
//  TimeUtil.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 26/05/15.
//  Copyright (c) 2015 YipYip. All rights reserved.
//

import Foundation

open class TimeUtils
{
	private var _iso8601DateFormatter = ISO8601DateFormatter()
    
    
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: - Public methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	open func dateFromISO8601TimeString(_ string:String)->Date?
	{
		return self._iso8601DateFormatter.date(from: string)
	}
    
    open func iso8601TimeStringFromDate(_ date:Date)->String?
    {
        return self._iso8601DateFormatter.string(from: date)
    }
}
