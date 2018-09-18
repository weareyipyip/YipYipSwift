//
//  ViewUtil.swift
//  YipYip Swift Library
//
//  Created by Marcel Bloemendaal on 22/09/15.
//  Copyright © 2016 YipYip. All rights reserved.
//

import Foundation
import UIKit

open class ViewUtils
{
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: Properties
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    open var singlePixelSizeInPoints:CGFloat
    {
        return CGFloat(1.0 / UIScreen.main.nativeScale)
    }
    
    
    // -----------------------------------------------------------------------------------------------------------------------
    //
    // MARK: Public methods
    //
    // -----------------------------------------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------
    // MARK: Hairlines
    // -----------------------------------------------------------
    
    open func addHairlineToTopOfView(_ view:UIView, hairlineColor:UIColor)->UIView
    {
        let dividerHeight = self.singlePixelSizeInPoints
        let newHairline = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: dividerHeight))
        newHairline.backgroundColor = hairlineColor
        view.addSubview(newHairline)
        return newHairline
    }
    
    open func addHairlineToBottomOfView(_ view:UIView, color:UIColor)->UIView
    {
        let dividerHeight:CGFloat = self.singlePixelSizeInPoints
        let newHairline = UIView(frame:CGRect(x: 0, y: view.frame.size.height - dividerHeight, width: view.frame.size.width, height: dividerHeight))
        newHairline.backgroundColor = color
        view.addSubview(newHairline)
        return newHairline
    }
    
    open func removeHairlineFromView(_ view:UIView)->Bool
    {
        if (view is UIImageView && view.bounds.size.height <= 1.0)
        {
            view.isHidden = true
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
    
    open func setLabelAttributedTextUsingExistingAttributes(label:UILabel, text:String)
    {
        var attributes:[NSAttributedString.Key:Any]?
        if let text = label.text
        {
            if text.count > 0
            {
                attributes = label.attributedText?.attributes(at: 0, effectiveRange: nil) as [NSAttributedString.Key:Any]?
            }
        }
        if attributes == nil
        {
            attributes = [NSAttributedString.Key:Any]()
        }
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    open func setLabelTextWithCustomLineSpacing(label:UILabel, text:String, lineSpacing:CGFloat)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
    }
    
    // -----------------------------------------------------------
    // MARK: Indicating activity
    // -----------------------------------------------------------
    
    open func indicateActivity(imageView:UIImageView, button:UIButton? = nil)
    {
        var animation:CAAnimation
        
        if button != nil
        {
            button!.setTitle("", for: UIControl.State())
            button!.setTitle("", for: .highlighted)
            button!.setTitle("", for: .disabled)
        }
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        basicAnimation.toValue = CGFloat.pi * 2.0
        basicAnimation.duration = 2.0
        basicAnimation.repeatCount = 99999999
        animation = basicAnimation
        
        imageView.layer.add(animation, forKey: "rotation")
        imageView.isHidden = false
    }
    
    open func stopIndicatingActivity(imageView:UIImageView, button:UIButton? = nil, buttonTitle:String? = nil)
    {
        imageView.isHidden = true
        imageView.layer.removeAllAnimations()
        
        if button != nil && buttonTitle != nil
        {
            button!.setTitle(buttonTitle!, for: UIControl.State())
            button!.setTitle(buttonTitle!, for: .highlighted)
            button!.setTitle(buttonTitle!, for: .disabled)
        }
    }
    
    // -----------------------------------------------------------
    // -- Feedback animations
    // -----------------------------------------------------------
    
    open func shakeView(_ view:UIView)
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint:CGPoint(x: view.center.x - 10.0, y: view.center.y))
        animation.toValue = NSValue(cgPoint:CGPoint(x: view.center.x + 10.0, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    // -----------------------------------------------------------
    // MARK: Moving views to clear the keyboard
    // -----------------------------------------------------------
    
    open func scrollChild(_ child:UIView, ofScrollView scrollView:UIScrollView, clearOfKeyboardWithDidChangeFrameNotification notification:Notification, andMargin margin:CGFloat)
    {
        if let keyboardFrame = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let window = scrollView.window
        {
            let childFrame = child.convert(child.bounds, to: window)
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
    // -- Loading views from Xib
    // -----------------------------------------------------------

    open func addViewFromNib(nibName name:String, bundle:Bundle? = nil, toOwner containerView:UIView) -> UIView
    {
        let bundleToUse = bundle == nil ? Bundle(for: type(of: containerView)) : bundle
        let views = UINib(nibName: name, bundle: bundleToUse).instantiate(withOwner: containerView, options: nil) as [AnyObject]
        
        var  view = UIView()
        if let nibView = views[0] as? UIView{
            view = nibView
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: [], metrics: nil, views: ["view":view]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view":view]))
        
        return view
    }
    
    open func nibExists(name:String, bundle:Bundle? = nil)->Bool{
        var exists = false
        let bundleToUse = bundle == nil ? Bundle.main : bundle
        if bundleToUse?.path(forResource: name, ofType: "nib") != nil{
            exists = true
        }
        return exists
    }
    
    // -----------------------------------------------------------
    // -- Loading of images
    // -----------------------------------------------------------
    
    open func loadRemoteImageFromURLString(_ urlString:String, inImageView imageView:UIImageView, completion:((Bool)->())? = nil)->URLSessionDataTask?
    {
        var imageDownloadTask:URLSessionDataTask?
        
        // Download (and set) image if one is specified
        if let url = URL(string: urlString)
        {
            // Load image in background
            let urlRequest = NSMutableURLRequest(url: url) as URLRequest
            let urlSession = URLSession.shared
            imageDownloadTask = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
                var success = false
                if error == nil
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            if let image = UIImage(data: data!)
                            {
                                success = true
                                DispatchQueue.main.async(execute: { () -> Void in
                                    imageView.image = image
                                    completion?(true)
                                })
                            }
                        }
                    }
                }
                if !success
                {
                    DispatchQueue.main.async(execute: {
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
    
    open func numberBadgeWithNumber(_ number:Int, textColor:UIColor = UIColor.white, badgeColor:UIColor = UIColor.red, font:UIFont = UIFont.systemFont(ofSize: 12.0), height:CGFloat = 18.0)->UIView
    {
        // Panel
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = height * 0.5
        view.backgroundColor = badgeColor
        view.isUserInteractionEnabled = false
        
        // Label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.font = font
        label.textColor = UIColor.white
        label.text = "\(number)"
        view.addSubview(label)
        
        // Layout
        let views = ["label":label]
        let metrics = ["height": height, "margin": (height - font.pointSize) * 0.5]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=margin-[label(>=8)]->=margin-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label(height)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0))
        return view
    }
    
    // -----------------------------------------------------------
    // -- Measuring views
    // -----------------------------------------------------------
    
    open func measureHeightOfView(_ view:UIView, withFixedWidth width:CGFloat)->CGFloat
    {
        var widthConstraint:NSLayoutConstraint?
        var originalWidthConstraintConstant:CGFloat?
        
        // Find dimensional constraint in specified direction
        for constraint in view.constraints
        {
            if constraint.firstAttribute == .width && constraint.secondItem == nil
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
            widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: width)
            view.addConstraint(widthConstraint!)
        }
        
        // Measure the height
		let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
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
