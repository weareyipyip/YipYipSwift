//
//  EmptyDataView.swift
//  YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//  Copyright © 2020 YipYip. All rights reserved.
//

import UIKit
import YipYipSwift

public class EmptyDataView: YipYipNibView, YipYipEmptyTableViewDataView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    public weak var delegate: EmptyTableViewDataViewDelegate?
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    public var title: String? {
        didSet {
            self.titleLabel.isHidden = self.title == nil
            self.titleLabel.text = self.title
        }
    }
    
    public var message: String? {
        didSet {
            self.messageLabel.isHidden = self.message == nil
            self.messageLabel.text = self.message
        }
    }
    
    public var actionButtonTitle: String? {
        didSet {
            self.actionButton.isHidden = self.actionButtonTitle == nil
            self.actionButton.setTitle(self.actionButtonTitle, for: .normal)
        }
    }
    
    // ----------------------------------------------------
    // MARK: -- View life cycle
    // ----------------------------------------------------
    
    override public func viewDidLayout() {
        super.viewDidLayout()
        
        self.titleLabel.isHidden = true
        self.messageLabel.isHidden = true
        self.actionButton.isHidden = true
    }
    
    // ----------------------------------------------------
    // MARK: - User interaction
    // ----------------------------------------------------
    
    @IBAction func userDidTapConversionButton(_ sender: Any) {
        self.delegate?.userDidTapActionButton(in: self)
    }
}
