//
//  CardView.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import UIKit
import YipYipSwift

internal class CardView: YipYipNibView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Observed properties
    // ----------------------------------------------------
    
    internal var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    internal var subtitle: String? {
        didSet {
            self.subtitleLabel.text = self.subtitle
        }
    }
    
    internal var maxLines: Int = 1 {
        didSet {
            self.subtitleLabel.numberOfLines = self.maxLines
        }
    }
    
    // ----------------------------------------------------
    // MARK: - View cycle methods
    // ----------------------------------------------------
    
    override internal func viewDidLayout() {
        super.viewDidLayout()
        
        self.backgroundColor = .clear
        self.nibView.backgroundColor = .clear
        
        self.title = nil
        self.subtitle = nil
    }
    
}
