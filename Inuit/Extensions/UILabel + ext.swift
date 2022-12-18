//
//  UILabel + ext.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/28/22.
//

import UIKit

extension UILabel {
    func setAttributedTitle(with title: String, color: UIColor, fontSize: CGFloat = 25.0) {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Ilisarniq-Demi", size: fontSize)!,
            NSAttributedString.Key.foregroundColor: color
            ]
        let string = NSAttributedString(string: title, attributes: attributes)
        attributedText = string
    }
}
