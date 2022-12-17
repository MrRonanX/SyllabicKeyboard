//
//  UIGestureRecognizer + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 12/17/22.
//

import UIKit

extension UIGestureRecognizer {
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}
