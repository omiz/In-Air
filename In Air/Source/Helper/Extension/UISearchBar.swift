//
//  UISearchBar.swift
//  In Air
//
//  Created by Omar Allaham on 3/27/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

extension UISearchBar {

    open var textField: UITextField! {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return nil }
        return tf
    }

    var textColor: UIColor? {
        get {
            return textField?.textColor
        }
        set {
            textField?.textColor = newValue
        }
    }
}
