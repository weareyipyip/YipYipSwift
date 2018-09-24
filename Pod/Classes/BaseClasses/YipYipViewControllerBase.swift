//
//  PHViewController.swift
//  PersonHelp
//
//  Created by Rens Wijnmalen on 11/05/2018.
//  Copyright © 2018 YipYip. All rights reserved.
//

import UIKit

open class YipYipViewControllerBase: UIViewController {
    
    private var _lastKnownVisableKeyboardFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var _keyboardIsShown:Bool = false
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    public var lastKnownVisableKeyboardFrame:CGRect{
        return self._lastKnownVisableKeyboardFrame
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
        let didChange = self._keyboardIsShown == false
        self._keyboardIsShown = true
        self.adjustForKeyboard(notification: notification, willChangeVisability: didChange)
    }
    
    @objc open func keyboardWillChangeFrame(_ notification: Notification){
        self.adjustForKeyboard(notification: notification)
    }
    
    @objc open func keyboardWillHide(_ notification: Notification){
        let didChange = self._keyboardIsShown == true
        self._keyboardIsShown = false
        self.adjustForKeyboard(notification: notification, willChangeVisability: didChange)
    }
    
    @objc open func applicationWillEnterForground(_ notification: Notification){
        self.dismissKeyboard()
    }
    
    // Private
    private func adjustForKeyboard(notification: Notification, willChangeVisability:Bool = false){
        
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        guard let windowFrame = UIApplication.shared.keyWindow?.frame else { return }
        
        let newHeight = windowFrame.height - keyboardEndFrame.origin.y
        let newWidth = keyboardEndFrame.width
        let newOrgin = self.view.convert(keyboardEndFrame.origin, to: nil)
        let endVisableKeyboardRect = CGRect(x: newOrgin.x, y: newOrgin.y, width: newWidth, height: newHeight)
        
        if willChangeVisability || endVisableKeyboardRect != self._lastKnownVisableKeyboardFrame{
            self._lastKnownVisableKeyboardFrame = endVisableKeyboardRect
            self.keyboardWillUpdate(willBeShown: self._keyboardIsShown, newVisableKeyboardFrame: endVisableKeyboardRect, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
        }
    }
    
    // Open methods
    open func keyboardWillUpdate(willBeShown:Bool, newVisableKeyboardFrame: CGRect, animationDuration:TimeInterval, animationCurve:Int){
    }
    
    open func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
