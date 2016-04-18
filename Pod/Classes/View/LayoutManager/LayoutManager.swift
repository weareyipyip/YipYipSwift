//
//  LayoutManager.swift
//  YourLegalMatch
//
//  Created by Marcel Bloemendaal on 19/11/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation
import UIKit


public enum OptionalViewOptionalityDirection
{
	case Horizontal
	case Vertical
	case HorizontalAndVertical
}

public class LayoutManager
{
	private var _optionalViewsByID = [String:OptionalViewDescriptor]()
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: - Public methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	public func addOptionalView(view:UIView, id:String, optionalityDirection:OptionalViewOptionalityDirection, spacingConstraints:[NSLayoutConstraint]?)
	{
		self._optionalViewsByID[id] = OptionalViewDescriptor(view: view, optionalityDirection: optionalityDirection, spacingConstraints: spacingConstraints)
	}
	
	public func setOptionalViewPresent(viewID:String, present:Bool)
	{
		if let optionalView = self._optionalViewsByID[viewID]
		{
			optionalView.present = present
		}
	}
}