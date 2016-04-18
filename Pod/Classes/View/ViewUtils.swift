//
//  ViewUtil.swift
//  YipYip Swift Library
//
//  Created by Marcel Bloemendaal on 22/09/15.
//  Copyright © 2016 YipYip. All rights reserved.
//

import Foundation
import UIKit

public class ViewUtils
{
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: Properties
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	public var singlePixelSizeInPoints:CGFloat
	{
		return CGFloat(1.0 / UIScreen.mainScreen().nativeScale)
	}
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: Public methods
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	// -----------------------------------------------------------
	// MARK: Hairlines
	// -----------------------------------------------------------
	
	public func addHairlineToTopOfView(view:UIView, hairlineColor:UIColor)
	{
		let dividerHeight = self.singlePixelSizeInPoints
		let newHairline = UIView(frame:CGRectMake(0, 0, view.frame.size.width, dividerHeight))
		newHairline.backgroundColor = hairlineColor
		view.addSubview(newHairline)
	}
	
	public func addHairlineToBottomOfView(view:UIView, color:UIColor)
	{
		let dividerHeight:CGFloat = self.singlePixelSizeInPoints
		let newHairline = UIView(frame:CGRectMake(0, view.frame.size.height - dividerHeight, view.frame.size.width, dividerHeight))
		newHairline.backgroundColor = color
		view.addSubview(newHairline)
	}
	
	public func removeHairlineFromView(view:UIView)->Bool
	{
		if (view is UIImageView && view.bounds.size.height <= 1.0)
		{
			view.hidden = true
			return true
		}
		
		for subview in view.subviews
		{
			if self.removeHairlineFromView(subview)
			{
				return true
			}
		}
		return false
	}
	
	// -----------------------------------------------------------
	// MARK: Attributed text
	// -----------------------------------------------------------
	
	public func setLabelAttributedTextUsingExistingAttributes(label label:UILabel, text:String)
	{
		var attributes:[String:AnyObject]?
		if let text = label.text
		{
			if text.characters.count > 0
			{
				attributes = label.attributedText?.attributesAtIndex(0, effectiveRange: nil)
			}
		}
		if attributes == nil
		{
			attributes = [String:AnyObject]()
		}
		label.attributedText = NSAttributedString(string: text, attributes: attributes)
	}
    
    public func setLabelTextWithCustomLineSpacing(label label:UILabel, text:String, lineSpacing:CGFloat)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
    }
	
	// -----------------------------------------------------------
	// MARK: Indicating activity
	// -----------------------------------------------------------
	
	public func indicateActivity(imageView imageView:UIImageView, button:UIButton? = nil)
	{
		var animation:CAAnimation
		
		if button != nil
		{
			button!.setTitle("", forState: .Normal)
			button!.setTitle("", forState: .Highlighted)
			button!.setTitle("", forState: .Disabled)
		}
		let basicAnimation = CABasicAnimation(keyPath: "transform.rotation")
		basicAnimation.toValue = M_PI * 2.0
		basicAnimation.duration = 2.0
		basicAnimation.repeatCount = 99999999
		animation = basicAnimation
		
		imageView.layer.addAnimation(animation, forKey: "rotation")
		imageView.hidden = false
	}
	
	public func stopIndicatingActivity(imageView imageView:UIImageView, button:UIButton? = nil, buttonTitle:String? = nil)
	{
		imageView.hidden = true
		imageView.layer.removeAllAnimations()
		
		if button != nil && buttonTitle != nil
		{
			button!.setTitle(buttonTitle!, forState: .Normal)
			button!.setTitle(buttonTitle!, forState: .Highlighted)
			button!.setTitle(buttonTitle!, forState: .Disabled)
		}
	}
	
    // -----------------------------------------------------------
    // -- Loading of images
    // -----------------------------------------------------------
    
    public func loadRemoteImageFromURLString(urlString:String, inImageView imageView:UIImageView)->NSURLSessionDataTask?
	{
		var imageDownloadTask:NSURLSessionDataTask?
		
		// Download (and set) image if one is specified
		if let url = NSURL(string: urlString)
		{
			// Load image in background
			let urlRequest = NSMutableURLRequest(URL: url)
			let urlSession = NSURLSession.sharedSession()
			imageDownloadTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
				var success = false
				if error == nil
				{
					if let httpResponse = response as? NSHTTPURLResponse
					{
						if httpResponse.statusCode == 200
						{
							success = true
							dispatch_async(dispatch_get_main_queue(), { () -> Void in
								let image = UIImage(data: data!)
								imageView.image = image
							})
						}
					}
				}
				if !success
				{
					// TODO: set image placeholder
				}
			})
			imageDownloadTask!.resume()
		}
		return imageDownloadTask
	}
    
    // -----------------------------------------------------------
    // -- Badges
    // -----------------------------------------------------------
    
    public func numberBadgeWithNumber(number:Int, badgeColor:UIColor = UIColor.redColor())->UIView
    {
        // Panel
        let view = UIView()
        view.layer.cornerRadius = 9
        view.backgroundColor = badgeColor
        view.userInteractionEnabled = false
        
        // Label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.text = "\(number)"
        view.addSubview(label)
        
        // Layout
        let views = ["label":label]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|->=5-[label(>=8)]->=5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label(18)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        return view
    }
}
