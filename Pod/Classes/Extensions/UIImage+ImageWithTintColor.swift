//
//  UIImage+Extension.swift
//  Genova Fashion App
//
//  Created by Marcel Bloemendaal on 06/01/15.
//  Copyright (c) 2015 Marcel Bloemendaal. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage
{
	public func imageWithTintColor(color: UIColor) -> UIImage
	{
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		
		let context = UIGraphicsGetCurrentContext()!
		CGContextTranslateCTM(context, 0, self.size.height)
		CGContextScaleCTM(context, 1.0, -1.0)
		CGContextSetBlendMode(context, CGBlendMode.Normal)
		
		let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
		CGContextClipToMask(context, rect, self.CGImage)
		color.setFill()
		CGContextFillRect(context, rect)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
		UIGraphicsEndImageContext()
		
		return newImage
	}
}

