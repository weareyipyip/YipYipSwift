//
//  ConstraintUtils.swift
//  Pods-YipYipSwiftExample
//
//  Created by Rens Wijnmalen on 01/07/2020.
//

import UIKit

public class ConstraintUtils {
    
    /**
     Returns the height layoutconstraint of the view
     */
    public static func heightConstraint(for view: UIView) -> NSLayoutConstraint? {
        return ConstraintUtils.constraint(for: view, withFirstAttribute: .height)
    }
    
    /**
     Returns the width layout constraint of the view
     */
    public static func widthConstraint(for view: UIView) -> NSLayoutConstraint? {
        return ConstraintUtils.constraint(for: view, withFirstAttribute: .width)
    }
    
    /**
    Returns the first layout constraint where the first attribute is the given attribute
    */
    public static func constraint(for view: UIView, withFirstAttribute firstAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in view.constraints {
            if constraint.firstAttribute == firstAttribute {
                return constraint
            }
        }
        return nil
    }
    
    /**
    Returns the first layout constraint where the identifier is the given identifier
    */
    public static func constraint(for view: UIView, withIdentifier identifier: String) -> NSLayoutConstraint? {
        for constraint in view.constraints {
            if constraint.identifier == identifier {
                return constraint
            }
        }
        return nil
    }
    
}
