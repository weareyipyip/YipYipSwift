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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - Keyboard methods
    // ----------------------------------------------------
    
    open func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification){
        
        if let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            let keyboardHeightDidChange = self.lastKnownKeyboardHeight != keyboardEndFrame.height
            if self._keyboardIsShown, keyboardHeightDidChange{
                self.keyboardWillChange(notification: notification)
            } else if keyboardHeightDidChange {
                self.keyboardWillEnter(notification: notification)
            }
            
            let keyboardSizeWillChange = self._keyboardIsShown
            self._keyboardIsShown = true
            
            self._lastKnownKeyboardHeight = keyboardEndFrame.height
            guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            guard let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
            if keyboardSizeWillChange, keyboardHeightDidChange{
                self.keyboardWillChange(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
            } else if keyboardHeightDidChange {
                self.keyboardWillEnter(keyboardEndFrame: keyboardEndFrame, animationDuration: keyboardAnimationDuration, animationCurve: keyboardAnimationCurve)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification){
        self.keyboardWillHide(notification: notification)
        
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
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
