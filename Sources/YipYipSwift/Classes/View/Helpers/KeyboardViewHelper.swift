//
//  KeyboardViewHelper.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import UIKit

public protocol KeyboardViewHelperDelegate: AnyObject {
    func keyboardWillUpdate(willBeShown: Bool, newVisibleKeyboardFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int)
}

open class KeyboardViewHelper {
    
    private var _lastKnownVisibleKeyboardFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var _keyboardIsShown: Bool = false
    private let _mainView: UIView
    
    open weak var delegate: KeyboardViewHelperDelegate?
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    open var lastKnownVisibleKeyboardFrame: CGRect {
        return self._lastKnownVisibleKeyboardFrame
    }
    
    open var keyboardIsShown: Bool {
        return self._keyboardIsShown
    }
    
    // ----------------------------------------------------
    // MARK: - Initializers
    // ----------------------------------------------------
    
    public init(mainView: UIView) {
        self._mainView = mainView
    }
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    open func viewWillAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    open func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - Public methods
    // ----------------------------------------------------
    
    open func keyboardWillUpdate(willBeShown: Bool, newVisibleKeyboardFrame: CGRect, animationDuration: TimeInterval, animationCurve: Int) {
        self.delegate?.keyboardWillUpdate(willBeShown: willBeShown, newVisibleKeyboardFrame: newVisibleKeyboardFrame, animationDuration: animationDuration, animationCurve: animationCurve)
    }
    
    open func dismissKeyboard() {
        self._mainView.endEditing(true)
    }
    
    // ----------------------------------------------------
    // MARK: - Notification methods
    // ----------------------------------------------------
    
    @objc private func keyboardWillShow(_ notification: Notification){
        let didChange = !self._keyboardIsShown
        self._keyboardIsShown = true
        self.processKeyboardChange(notification: notification, willChangeVisibility: didChange)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification){
        self.processKeyboardChange(notification: notification, willChangeVisibility: false)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification){
        let didChange = self._keyboardIsShown
        self._keyboardIsShown = false
        self.processKeyboardChange(notification: notification, willChangeVisibility: didChange)
    }
    
    @objc private func applicationWillEnterForground(_ notification: Notification){
        self.dismissKeyboard()
    }
    
    // ----------------------------------------------------
    // MARK: - Private methods
    // ----------------------------------------------------
    
    private func processKeyboardChange(notification: Notification, willChangeVisibility: Bool){
        
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let windowFrame = self._mainView.window?.frame else {
                return
        }
        
        let newHeight = windowFrame.height - keyboardEndFrame.origin.y
        let newWidth = keyboardEndFrame.width
        let newOrgin = self._mainView.convert(keyboardEndFrame.origin, to: nil)
        let endVisibleKeyboardRect = CGRect(x: newOrgin.x, y: newOrgin.y, width: newWidth, height: newHeight)
        
        if willChangeVisibility || endVisibleKeyboardRect != self._lastKnownVisibleKeyboardFrame{
            self._lastKnownVisibleKeyboardFrame = endVisibleKeyboardRect
            self.keyboardWillUpdate(willBeShown: self._keyboardIsShown,
                                    newVisibleKeyboardFrame: endVisibleKeyboardRect,
                                    animationDuration: keyboardAnimationDuration,
                                    animationCurve: keyboardAnimationCurve)
        }
    }
    
}

