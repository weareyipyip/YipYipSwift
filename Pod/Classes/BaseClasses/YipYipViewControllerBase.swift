//
//  PHViewController.swift
//  PersonHelp
//
//  Created by Rens Wijnmalen on 11/05/2018.
//  Copyright © 2018 YipYip. All rights reserved.
//

import UIKit

open class YipYipViewControllerBase: UIViewController {
    
    private var _keyboardIsShown: Bool = false
    private var _lastKnownKeyboardHeight: CGFloat = 0
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    public var keyboardIsShown: Bool{
        return self._keyboardIsShown
    }
    
    public var lastKnownKeyboardHeight: CGFloat{
        return self._lastKnownKeyboardHeight
    }
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForground(_:)), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - Keyboard methods
    // ----------------------------------------------------
    
    open func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification){
        
        if let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            
            if self._keyboardIsShown{
                if self.lastKnownKeyboardHeight != keyboardEndFrame.height{
                    self.keyboardWillChange(notification: notification)
                }
            } else {
                self.keyboardWillEnter(notification: notification)
            }
            
            let keyboardSizeWillChange = self._keyboardIsShown
            self._keyboardIsShown = true
            
            self._lastKnownKeyboardHeight = keyboardEndFrame.height
            guard let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            guard let keyboardAnimationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int else { return }
            if keyboardSizeWillChange{
                if self.lastKnownKeyboardHeight != keyboardEndFrame.height{
                    self.keyboardWillChange(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
                }
            } else {
                self.keyboardWillEnter(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification){
        self.keyboardWillHide(notification: notification)
        
        guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let keyboardAnimationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Int else { return }
        self.keyboardWillHide(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
        self._keyboardIsShown = false
    }
    
    @objc private func applicationWillEnterForground(_ notification: Notification){
        self.dismissKeyboard()
    }
    
    open func keyboardWillEnter(keyboardEndFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int){
    }
    
    open func keyboardWillEnter(notification: Notification){
    }
    
    open func keyboardWillChange(keyboardEndFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int){
        // keyboardWillEnter will be called by default. If other behavour is required override this method in your controller and do not call the super method.
        self.keyboardWillEnter(keyboardEndFrame: keyboardEndFrame, animationDuration: animationDuration, animationCurve: animationCurve)
    }
    
    open func keyboardWillChange(notification: Notification){
        // keyboardWillEnter will be called by default. If other behavour is required override this method in your controller and do not call the super method.
        self.keyboardWillEnter(notification: notification)
    }
    
    open func keyboardWillHide(keyboardEndFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int){
    }
    
    open func keyboardWillHide(notification: Notification){
    }
}