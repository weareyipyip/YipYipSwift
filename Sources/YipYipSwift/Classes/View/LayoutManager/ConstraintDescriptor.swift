//
//  ConstraintDescriptor.swift
//  YipYipSwift
//
//  Created by Marcel Bloemendaal on 30/08/16.
//  Copyright © 2015 YipYip. All rights reserved.
//

import Foundation
import UIKit

class ConstraintDescriptor {
	let constraint:NSLayoutConstraint
	let originalConstant:CGFloat
	
	
	// -----------------------------------------------------------------------------------------------------------------------
	//
	// MARK: Initializers
	//
	// -----------------------------------------------------------------------------------------------------------------------
	
	init(constraint:NSLayoutConstraint) {
		self.constraint = constraint
		self.originalConstant = constraint.constant
	}
}
