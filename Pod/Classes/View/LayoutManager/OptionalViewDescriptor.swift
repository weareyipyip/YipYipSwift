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
	private (set) var spacingConstraints = [NSLayoutConstraint]()
	
	private var _originalWidthConstraintConstant:CGFloat?
	private var _originalHeightConstraintConstant:CGFloat?
	private var _widthConstraint:NSLayoutConstraint?
	private var _heightConstraint:NSLayoutConstraint?
	private var _present = true
	private var _originalSpacingConstraintsConstants = [CGFloat]()
	
	
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
					self._widthConstraint = constraint
					break outerLoop
				}
				
				
			case .Vertical:
				if constraint.firstAttribute == .Height
				{
					self._heightConstraint = constraint
					break outerLoop
				}
				
			case .HorizontalAndVertical:
				if constraint.firstAttribute == .Width
				{
					self._widthConstraint = constraint
					if self._heightConstraint != nil
					{
						break outerLoop
					}
				}
				else if constraint.firstAttribute == .Height
				{
					self._heightConstraint = constraint
					if self._widthConstraint != nil
					{
						break outerLoop
					}
				}
			}
		}
		
		// Set original constants if needed
		if let widthConstraint = self._widthConstraint
		{
			self._originalWidthConstraintConstant = widthConstraint.constant
		}
		if let heightConstraint = self._heightConstraint
		{
			self._originalHeightConstraintConstant = heightConstraint.constant
		}
		
		// Store and set orignal constants for spacing constraints
		if spacingConstraints != nil
		{
			for spacingConstraint in spacingConstraints!
			{
				self.spacingConstraints.append(spacingConstraint)
				self._originalSpacingConstraintsConstants.append(spacingConstraint.constant)
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
					let numSpacingConstraints = self.spacingConstraints.count
					for index in 0..<numSpacingConstraints
					{
						self.spacingConstraints[index].constant = self._originalSpacingConstraintsConstants[index]
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
					for spacingConstraint in self.spacingConstraints
					{
						spacingConstraint.constant = 0.0
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
		if self._originalWidthConstraintConstant != nil
		{
			self._widthConstraint!.constant = 0.0
		}
		else
		{
			self._widthConstraint = NSLayoutConstraint(item: self.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
			self.view.addConstraint(self._widthConstraint!)
		}
	}
	
	private func expandHorizontally()
	{
		if self._originalWidthConstraintConstant != nil
		{
			self._widthConstraint!.constant = self._originalWidthConstraintConstant!
		}
		else
		{
			self.view.removeConstraint(self._widthConstraint!)
			self._widthConstraint = nil
		}
	}

	private func collapseVertically()
	{
		if self._originalHeightConstraintConstant != nil
		{
			self._heightConstraint!.constant = 0.0
		}
		else
		{
			self._heightConstraint = NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
			self.view.addConstraint(self._heightConstraint!)
		}
	}
	
	private func expandVertically()
	{
		if self._originalHeightConstraintConstant != nil
		{
			self._heightConstraint!.constant = self._originalHeightConstraintConstant!
		}
		else
		{
			self.view.removeConstraint(self._heightConstraint!)
			self._heightConstraint = nil
		}
	}
}
