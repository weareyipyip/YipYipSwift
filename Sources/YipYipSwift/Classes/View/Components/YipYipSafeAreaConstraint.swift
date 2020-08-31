//
//  YipYipSafeAreaConstraint.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 03/07/2020.
//

import Foundation

import UIKit

public class YipYipSafeAreaLayoutConstraint: NSLayoutConstraint {

    public enum Position: String {
        case left
        case right
        case top
        case bottom
    }
    
    
    // ----------------------------------------------------
    // MARK: - Properties
    // ----------------------------------------------------
    
    private var position: Position = .bottom
    
    
    // ----------------------------------------------------
    // MARK: - (de)initializers
    // ----------------------------------------------------
    
    public override init() {
        super.init()
        self.setup()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.updateConstant()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    private var safeAreaInsets: UIEdgeInsets? {
        if #available(iOS 11.0, *) {
            let windows = UIApplication.shared.windows
            guard windows.count > 0 else {
                return nil
            }
            let window = windows[0]
            return window.safeAreaInsets
        }
        return nil
    }
    
    private var safeAreaAvailable: Bool {
        guard let safeAreaInsets = self.safeAreaInsets else {
            return false
        }
        
        switch self.position {
        case .top:
            return safeAreaInsets.top > 0
        case .bottom:
            return safeAreaInsets.bottom > 0
        case .left:
            return safeAreaInsets.left > 0
        case .right:
            return safeAreaInsets.right > 0
        }
    }
    
    @available(*, unavailable, message: "Do not use this property Use 'safeAreaConstant' or 'noSafeAreaConstant' instead")
    public override var constant: CGFloat {
        didSet {
            // Do nothing. This override is to add the mesasage to not use this property.
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'position' instead.")
    @IBInspectable open var positionName: String {
        get {
            return self.position.rawValue
        }
        set {
            self.position = Position(rawValue: newValue) ?? .bottom
        }
    }
    
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
    
    
    // ----------------------------------------------------
    // MARK: - Updates
    // ----------------------------------------------------
    
    private func updateConstant() {
        if self.safeAreaAvailable {
            super.constant = self._safeAreaConstant
        } else {
            super.constant = self._noSafeAreaConstant
        }
    }
    
    @objc private func orientationDidChange() {
        self.updateConstant()
    }
    
}
