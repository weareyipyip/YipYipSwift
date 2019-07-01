//
//  LayoutManager.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 19/11/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation
import UIKit


public enum OptionalViewOptionalityDirection
{
	case horizontal
	case vertical
	case horizontalAndVertical
}

open class LayoutManager
{
    
	private var _optionalViewsByID = [String:OptionalViewDescriptor]()
    private var _groupsByID = [String:[OptionalViewDescriptor]]()
    private var _ungroupedOptionalViews = [OptionalViewDescriptor]()
	
	
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: - Initializers
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    public init()
    {
        
    }
    
    
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: - Public methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
    open func addOptionalView(_ view:UIView, id:String, optionalityDirection:OptionalViewOptionalityDirection, spacingConstraints:[NSLayoutConstraint]?, hideInitially:Bool, groupID:String? = nil)
	{
        let optionalViewDescriptor = OptionalViewDescriptor(view: view, optionalityDirection: optionalityDirection, spacingConstraints: spacingConstraints, groupID: groupID)
        self._optionalViewsByID[id] = optionalViewDescriptor
        if let groupID = groupID {
            if self._groupsByID[groupID] == nil {
                self._groupsByID[groupID] = [optionalViewDescriptor]
            } else {
                self._groupsByID[groupID]!.append(optionalViewDescriptor)
            }
        } else {
            self._ungroupedOptionalViews.append(optionalViewDescriptor)
        }
        
        if hideInitially
        {
            optionalViewDescriptor.present = false
        }
	}
	
	open func setOptionalViewPresent(_ viewID:String, present:Bool)
	{
		if let optionalView = self._optionalViewsByID[viewID]
		{
			optionalView.present = present
		}
	}
    
    open func setGroupPresent(_ groupID:String?, present:Bool)
    {
        var group:[OptionalViewDescriptor]?
        if let groupID = groupID {
            group = self._groupsByID[groupID]
        } else {
            group = self._ungroupedOptionalViews
        }
        if let group = group {
            for optionalViewDescriptor in group {
                optionalViewDescriptor.present = present
            }
        }
    }
    
    open func isOptionalViewIsPresent(_ id: String) -> Bool
    {
		var present = false
        if let view = self._optionalViewsByID[id] {
            present = view.present
        }
        return present
    }
}
