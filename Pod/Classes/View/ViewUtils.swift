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
    // -- Feedback animations
    // -----------------------------------------------------------
    
    public func shakeView(view:UIView)
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint:CGPoint(x: view.center.x - 10.0, y: view.center.y))
        animation.toValue = NSValue(CGPoint:CGPoint(x: view.center.x + 10.0, y: view.center.y))
        view.layer.addAnimation(animation, forKey: "position")
    }
    
	// -----------------------------------------------------------
	// MARK: Moving views to clear the keyboard
	// -----------------------------------------------------------
	
	public func scrollChild(child:UIView, ofScrollView scrollView:UIScrollView, clearOfKeyboardWithDidChangeFrameNotification notification:NSNotification, andMargin margin:CGFloat)
	{
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(), window = scrollView.window
        {
            let childFrame = child.convertRect(child.bounds, toView: window)
            let keyboardTop = keyboardFrame.minY
            let desiredChildScreenBottomY = keyboardTop - margin
            
            let childScreenBottomY = childFrame.maxY
            let additionalContentOffsetY = childScreenBottomY - desiredChildScreenBottomY
            if additionalContentOffsetY > 0
            {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + additionalContentOffsetY), animated: true)
            }
        }
	}
	
    // -----------------------------------------------------------
    // -- Loading of images
    // -----------------------------------------------------------
    
    public func loadRemoteImageFromURLString(urlString:String, inImageView imageView:UIImageView, completion:((Bool)->())? = nil)->NSURLSessionDataTask?
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
                            if let image = UIImage(data: data!)
                            {
                                success = true
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    imageView.image = image
                                    completion?(true)
                                })
                            }
                        }
                    }
                }
                if !success
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion?(success)
                    })
                }
            })
            imageDownloadTask!.resume()
        }
        return imageDownloadTask
    }
    
    // -----------------------------------------------------------
    // -- Badges
    // -----------------------------------------------------------
    
    public func numberBadgeWithNumber(number:Int, textColor:UIColor = UIColor.whiteColor(), badgeColor:UIColor = UIColor.redColor(), font:UIFont = UIFont.systemFontOfSize(12.0), height:CGFloat = 18.0)->UIView
    {
        // Panel
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = height * 0.5
        view.backgroundColor = badgeColor
        view.userInteractionEnabled = false
        
        // Label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        label.font = font
        label.textColor = UIColor.whiteColor()
        label.text = "\(number)"
        view.addSubview(label)
        
        // Layout
        let views = ["label":label]
        let metrics = ["height": height, "margin": (height - font.pointSize) * 0.5]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|->=margin-[label(>=8)]->=margin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label(height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0))
        return view
    }
    
    // -----------------------------------------------------------
    // -- Measuring views
    // -----------------------------------------------------------
    
    public func measureHeightOfView(view:UIView, withFixedWidth width:CGFloat)->CGFloat
    {
        var widthConstraint:NSLayoutConstraint?
        var originalWidthConstraintConstant:CGFloat?
        
        // Find dimensional constraint in specified direction
        for constraint in view.constraints
        {
            if constraint.firstAttribute == .Width && constraint.secondItem == nil
            {
                originalWidthConstraintConstant = constraint.constant
                widthConstraint = constraint
                constraint.constant = width
                break
            }
        }
        
        // Add new width constraint if none was found
        if widthConstraint == nil
        {
            widthConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: width)
            view.addConstraint(widthConstraint!)
        }
        
        // Measure the height
        let height = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        // Restore view to its original state
        if originalWidthConstraintConstant == nil
        {
            view.removeConstraint(widthConstraint!)
        }
        else
        {
            widthConstraint!.constant = originalWidthConstraintConstant!
        }
        
        return height
    }
}
