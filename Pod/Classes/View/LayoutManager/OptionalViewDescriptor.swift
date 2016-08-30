//
//  OptionalViewDescriptor.swift
//  YourLegalMatch
//
//  Created by Marcel Bloemendaal on 19/11/15.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation
import UIKit

class OptionalViewDescriptor
{
	private (set) var view:UIView
	private (set) var optionalityDirection:OptionalViewOptionalityDirection
	private (set) var spacingConstraints = [ConstraintDescriptor]()
	
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
	
	init(view:UIView, optionalityDirection:OptionalViewOptionalityDirection, spacingConstraints:[NSLayoutConstraint]?)
	{
		// Store parameters
		self.view = view
		self.optionalityDirection = optionalityDirection
		
		// Find dimensional constraint in specified direction
		outerLoop: for constraint in view.constraints
		{
			switch self.optionalityDirection
			{
			case .Horizontal:
				if constraint.firstAttribute == .Width
				{
					self._originalWidthConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
				
			case .Vertical:
				if constraint.firstAttribute == .Height
				{
					self._originalHeightConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
				
			case .HorizontalAndVertical:
				if constraint.firstAttribute == .Width
				{
					self._originalWidthConstraints.append(ConstraintDescriptor(constraint: constraint))
				}
				else if constraint.firstAttribute == .Height
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
					case .Horizontal:
						self.expandHorizontally()
						
					case .Vertical:
						self.expandVertically()
						
					case .HorizontalAndVertical:
						self.expandHorizontally()
						self.expandVertically()
					}
					self.view.hidden = false
					
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
					case .Horizontal:
						self.collapseHorizontally()
						
					case .Vertical:
						self.collapseVertically()
						
					case .HorizontalAndVertical:
						self.collapseHorizontally()
						self.collapseVertically()
					}
					self.view.hidden = true
					
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
			self._widthConstraint = NSLayoutConstraint(item: self.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
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
			self._heightConstraint = NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
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
