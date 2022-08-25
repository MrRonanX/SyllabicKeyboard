//
//  UITraitCollection + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/25/22.
//

import UIKit

extension UITraitCollection {
    
    var orientation: UIInterfaceOrientation {
        if verticalSizeClass == .regular && horizontalSizeClass == .compact {
            return .portrait
        } else if verticalSizeClass == .compact && horizontalSizeClass == .regular {
            return .landscapeLeft
        } else if verticalSizeClass == .compact && horizontalSizeClass == .compact {
            return .landscapeLeft
        } else if verticalSizeClass == .regular && horizontalSizeClass == .regular {
            let bounds = UIScreen.main.bounds
            if bounds.height > bounds.width {
                return .portrait
            } else {
                return .landscapeLeft
            }
        } else if verticalSizeClass == .regular && horizontalSizeClass == .compact {
            return .portrait
        } else {
            return .unknown
        }
    }
}
