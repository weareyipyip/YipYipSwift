//
//  OptionalViewDescriptor.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 19/11/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation
import UIKit

class OptionalViewDescriptor
{
	private var view:UIView
	private var optionalityDirection:OptionalViewOptionalityDirection
	private var spacingConstraints = [ConstraintDescriptor]()
    private (set) var groupID:String?
	
	private var _originalWidthConstraints = [ConstraintDescriptor]()
	private var _originalHeightConstraints = [ConstraintDescriptor]()
	private var _widthConstraint:NSLayoutConstraint?
	private var _heightConstraint:NSLayoutConstraint?
	private var _present = true
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: - Initializers
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
    init(view:UIView, optionalityDirection:OptionalViewOptionalityDirection, spacingConstraints:[NSLayoutConstraint]?, groupID:String? = nil)
	{
		// Store parameters
		self.view = view
		self.optionalityDirection = optionalityDirection
        self.groupID = groupID
		
		// Find dimensional constraint in specified direction
		outerLoop: for constraint in view.constraints
		{
			switch self.optionalityDirection
			{
			case .horizontal:
				if constraint.firstAttribute == .width
				{
					self._originalWidthConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
				
			case .vertical:
				if constraint.firstAttribute == .height
				{
					self._originalHeightConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
				
			case .horizontalAndVertical:
				if constraint.firstAttribute == .width
				{
					self._originalWidthConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
				else if constraint.firstAttribute == .height
				{
					self._originalHeightConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
			}
		}
		
		// Store and set orignal constants for spacing constraints
		if spacingConstraints != nil
		{
			for spacingConstraint in spacingConstraints!
			{
				self.spacingConstraints.append(ConstraintDescriptor(constraint: spacingConstraint))
			}
		}
	}
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: - Properties
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	var present:Bool
		{
		set(newValue)
		{
			if self._present != newValue
			{
				self._present = newValue
				if self._present
				{
					// Expand view itself
					switch self.optionalityDirection
					{
					case .horizontal:
						self.expandHorizontally()
						
					case .vertical:
						self.expandVertically()
						
					case .horizontalAndVertical:
						self.expandHorizontally()
						self.expandVertically()
					}
					self.view.isHidden = false
					
					// Expand spacingConstraints
					for constraintDescriptor in self.spacingConstraints
					{
						constraintDescriptor.constraint.constant = constraintDescriptor.originalConstant
					}
				}
				else
				{
					// Collapse view itself
					switch self.optionalityDirection
					{
					case .horizontal:
						self.collapseHorizontally()
						
					case .vertical:
						self.collapseVertically()
						
					case .horizontalAndVertical:
						self.collapseHorizontally()
						self.collapseVertically()
					}
					self.view.isHidden = true
					
					// Collapse spacing constraints
					for constraintDescriptor in self.spacingConstraints
					{
						constraintDescriptor.constraint.constant = 0.0
					}
				}
			}
		}
		
		get
		{
			return self._present
		}
	}
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: Private methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	private func collapseHorizontally()
	{
		if self._originalWidthConstraints.count > 0
		{
			for constraintDescriptor in self._originalWidthConstraints {
				constraintDescriptor.constraint.constant = 0.0
			}
		}
		else
		{
			self._widthConstraint = NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
			self.view.addConstraint(self._widthConstraint!)
		}
	}
	
	private func expandHorizontally()
	{
		if self._originalWidthConstraints.count > 0
		{
			for constraintDescriptor in self._originalWidthConstraints {
				constraintDescriptor.constraint.constant = constraintDescriptor.originalConstant
			}
		}
		else
		{
			self.view.removeConstraint(self._widthConstraint!)
			self._widthConstraint = nil
		}
	}
	
	private func collapseVertically()
	{
		if self._originalHeightConstraints.count > 0
		{
			for constraintDescriptor in self._originalHeightConstraints {
				constraintDescriptor.constraint.constant = 0.0
			}
		}
		else
		{
			self._heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
			self.view.addConstraint(self._heightConstraint!)
		}
	}
	
	private func expandVertically()
	{
		if self._originalHeightConstraints.count > 0
		{
			for constraintDescriptor in self._originalHeightConstraints {
				constraintDescriptor.constraint.constant = constraintDescriptor.originalConstant
			}
		}
		else
		{
			self.view.removeConstraint(self._heightConstraint!)
			self._heightConstraint = nil
		}
	}
}
