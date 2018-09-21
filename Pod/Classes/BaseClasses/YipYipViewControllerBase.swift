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
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    public var keyboardIsShown: Bool{
        return self._keyboardIsShown
    }
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - Keyboard methods
    // ----------------------------------------------------
    
    // Notifications
    
    @objc open func keyboardWillShow(_ notification: Notification){
        self.adjustForKeyboard(notification: notification)
    }
    
    @objc open func keyboardWillChangeFrame(_ notification: Notification){
        self.adjustForKeyboard(notification: notification)
    }
    
    @objc open func keyboardWillHide(_ notification: Notification){
        self.adjustForKeyboard(notification: notification)
    }
    
    @objc private func applicationWillEnterForground(_ notification: Notification){
        self.dismissKeyboard()
    }
    
    // Open methods
    
    open func adjustForKeyboard(notification: Notification){
        
        guard let keyboardBeginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        
        switch notification.name{
        case UIResponder.keyboardWillShowNotification:
            if !self._keyboardIsShown{
                self._keyboardIsShown = true
                self.keyboardWillEnter(notification: notification)
                self.keyboardWillEnter(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
            }
        case UIResponder.keyboardWillHideNotification:
            if self._keyboardIsShown{
                self._keyboardIsShown = false
                self.keyboardWillHide(notification: notification)
                self.keyboardWillHide(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
            }
        case UIResponder.keyboardWillChangeFrameNotification:
            if keyboardBeginFrame.origin.y != keyboardEndFrame.origin.y{
                self.keyboardWillChange(notification: notification)
                self.keyboardWillChange(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
            }
        default:
            break
        }
    }
    
    open func keyboardWillEnter(keyboardEndFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int){
    }
    
    open func keyboardWillEnter(notification: Notification){
    }
    
    open func keyboardWillChange(keyboardEndFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int){
    }
    
    open func keyboardWillChange(notification: Notification){
    }
    
    open func keyboardWillHide(keyboardEndFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int){
    }
    
    open func keyboardWillHide(notification: Notification){
    }
    
    open func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
