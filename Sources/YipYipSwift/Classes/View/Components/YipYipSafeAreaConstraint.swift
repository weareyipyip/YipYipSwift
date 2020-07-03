//
//  YipYipSafeAreaConstraint.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 03/07/2020.
//

import Foundation

import UIKit

public class YipYipSafeAreaLayoutConstraint: NSLayoutConstraint {

    private enum position: String {
        case leading
        case left
        case trailing
        case right
        case top
        case bottom
    }
    
    // ----------------------------------------------------
    // MARK: - (de)initializers
    // ----------------------------------------------------
    
    public override init() {
        super.init()
        self.updateConstant()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.updateConstant()
    }
    
    private func updateConstant() {
        if #available(iOS 11.0, *) {
            let windows = UIApplication.shared.windows
            guard windows.count > 0 else {
                return
            }
            let window = windows[0]
            if window.safeAreaInsets.bottom > 0 {
                self.constant = self._safeAreaConstant
            } else {
                self.constant = self._noSafeAreaConstant
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    private var _safeAreaConstant: CGFloat = 0
    @IBInspectable open var safeAreaConstant: CGFloat {
        set {
            self._safeAreaConstant = newValue
            self.updateConstant()
        }
        get {
            return self._safeAreaConstant
        }
    }
    
    private var _noSafeAreaConstant: CGFloat = 0
    @IBInspectable open var noSafeAreaConstant: CGFloat {
        set {
            self._noSafeAreaConstant = newValue
            self.updateConstant()
        }
        get {
            return self._noSafeAreaConstant
        }
    }
    
}
