//
//  PHViewController.swift
//  YipYipSwift
//
//  Created by Rens Wijnmalen on 11/05/2018.
//  Copyright © 2018 YipYip. All rights reserved.
//

import UIKit

open class YipYipViewControllerBase: UIViewController {
    
    private var _lastKnownVisibleKeyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var _keyboardIsShown:Bool = false
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    public var lastKnownVisibleKeyboardFrame:CGRect{
        return self._lastKnownVisibleKeyboardFrame
    }
    
    public var keyboardIsShown:Bool{
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
        let didChange = !self._keyboardIsShown
        self._keyboardIsShown = true
        self.processKeyboardChange(notification: notification, willChangeVisibility: didChange)
    }
    
    @objc open func keyboardWillChangeFrame(_ notification: Notification){
        self.processKeyboardChange(notification: notification, willChangeVisibility: false)
    }
    
    @objc open func keyboardWillHide(_ notification: Notification){
        let didChange = self._keyboardIsShown
        self._keyboardIsShown = false
        self.processKeyboardChange(notification: notification, willChangeVisibility: didChange)
    }
    
    @objc open func applicationWillEnterForground(_ notification: Notification){
        self.dismissKeyboard()
    }
    
    // Private
    private func processKeyboardChange(notification: Notification, willChangeVisibility:Bool){
        
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        guard let windowFrame = UIApplication.shared.keyWindow?.frame else { return }
        
        let newHeight = windowFrame.height - keyboardEndFrame.origin.y
        let newWidth = keyboardEndFrame.width
        let newOrgin = self.view.convert(keyboardEndFrame.origin, to: nil)
        let endVisibleKeyboardRect = CGRect(x: newOrgin.x, y: newOrgin.y, width: newWidth, height: newHeight)
        
        if willChangeVisibility || endVisibleKeyboardRect != self._lastKnownVisibleKeyboardFrame{
            self._lastKnownVisibleKeyboardFrame = endVisibleKeyboardRect
            self.keyboardWillUpdate(willBeShown: self._keyboardIsShown, newVisibleKeyboardFrame: endVisibleKeyboardRect, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
        }
    }
    
    // Open methods
    open func keyboardWillUpdate(willBeShown:Bool, newVisibleKeyboardFrame: CGRect, animationDuration:TimeInterval, animationCurve:Int){
    }
    
    open func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
