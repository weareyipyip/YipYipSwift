//
//  ExtendedButton.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 08/01/15.
//  Copyright (c) 2015 Marcel Bloemendaal. All rights reserved.
//

import Foundation
import UIKit

public class ExtendedButton: UIButton
{
	private var _normalBackgroundColor:UIColor = UIColor.blackColor()
	private var _highlightedBackgroundColor:UIColor = UIColor.whiteColor()
	private var _selectedBackgroundColor:UIColor = UIColor.whiteColor()
	private var _disabledBackgroundColor:UIColor = UIColor.whiteColor()
	
	private var _normalBorderColor:UIColor = UIColor.whiteColor()
	private var _highlightedBorderColor:UIColor = UIColor.whiteColor()
	private var _selectedBorderColor:UIColor = UIColor.whiteColor()
	private var _disabledBorderColor:UIColor = UIColor.whiteColor()
	
	@IBInspectable public var placeImageOnTheRight:Bool = false
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: Properties
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	override public var highlighted:Bool
		{
		get
		{
			return super.highlighted
		}
		set(value)
		{
			super.highlighted = value
			self.updateColors()
		}
	}
	
	override public var selected:Bool
	{
		get
		{
			return super.selected
		}
		set(value)
		{
			super.selected = value
			self.updateColors()
		}
	}
	
	override public var enabled:Bool
	{
		get
		{
			return super.enabled
		}
		set(value)
		{
			super.enabled = value
			self.updateColors()
		}
	}
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: Methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	// -----------------------------------------------------------
	//  UIButton overrides
	// -----------------------------------------------------------
	
	override public func imageRectForContentRect(contentRect: CGRect) -> CGRect
	{
		if self.placeImageOnTheRight
		{
			var frame = super.imageRectForContentRect(contentRect)
			frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) - self.imageEdgeInsets.right + self.imageEdgeInsets.left
			return frame
		}
		else
		{
			return super.imageRectForContentRect(contentRect)
		}
	}
	
	override public func titleRectForContentRect(contentRect: CGRect) -> CGRect
	{
		if self.placeImageOnTheRight
		{
			var frame = super.titleRectForContentRect(contentRect)
			frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth(self.imageRectForContentRect(contentRect))
			return frame
		}
		else
		{
			return super.titleRectForContentRect(contentRect)
		}
	}
	
	// -----------------------------------------------------------
	//  Extra state color properties
	// -----------------------------------------------------------
	
	public func setBackgroundColor(color:UIColor, forState:UIControlState)
	{
		switch (forState)
		{
		case UIControlState.Normal:
			_normalBackgroundColor = color
			break
			
		case UIControlState.Highlighted:
			_highlightedBackgroundColor = color
			break
			
		case UIControlState.Selected:
			_selectedBackgroundColor = color
			break
			
		case UIControlState.Disabled:
			_disabledBackgroundColor = color
			break
			
		default:
			break;
		}
		self.updateColors()
	}
	
	public func setBorderColor(color:UIColor, forState:UIControlState)
	{
		switch (forState)
		{
		case UIControlState.Normal:
			_normalBorderColor = color
			break
			
		case UIControlState.Highlighted:
			_highlightedBorderColor = color
			break
			
		case UIControlState.Selected:
			_selectedBorderColor = color
			break
			
		case UIControlState.Disabled:
			_disabledBorderColor = color
			break
			
		default:
			break
		}
		self.updateColors()
	}
	
	private func updateColors()
	{
		if self.enabled
		{
			if (self.highlighted)
			{
				self.backgroundColor = _highlightedBackgroundColor
				self.layer.borderColor = _highlightedBorderColor.CGColor
			}
			else if (self.selected)
			{
				self.backgroundColor = _selectedBackgroundColor
				self.layer.borderColor = _selectedBorderColor.CGColor
			}
			else
			{
				self.backgroundColor = _normalBackgroundColor
				self.layer.borderColor = _normalBorderColor.CGColor
			}
		}
		else
		{
			self.backgroundColor = self._disabledBackgroundColor
			self.layer.borderColor = self._disabledBorderColor.CGColor
		}
	}
}
