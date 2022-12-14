//
//  UIButton + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/25/22.
//

import UIKit

extension UIButton {
    func setCustomFont(with title: String, color: UIColor, size: CGFloat = 22.0) {
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Ilisarniq-Demi", size: size)!,
            NSAttributedString.Key.foregroundColor: color
            ]
        let string = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(string, for: .normal)
    }
}

extension KeyboardButton {
    func pushToRight(_ image: UIImage, padding: CGFloat = 10) {
        contentHorizontalAlignment = .trailing
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = image
            configuration.imagePadding = padding
            self.configuration = configuration
        } else {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding)
        }
    }
    
    func addTopPadding() {
        titleEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func resizeImageView() {
        guard let imageView = imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.priority = .init(rawValue: 999)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    func resizeRight(with buttonSize: CGFloat) {
        guard let imageView = imageView else { return }
        let constant = buttonSize > 40 ? 20 : buttonSize / 2
        contentHorizontalAlignment = .trailing
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            imageView.heightAnchor.constraint(equalToConstant: constant),
            imageView.widthAnchor.constraint(equalToConstant: buttonSize)
            ]
        
        constraints.forEach { $0.priority = .init(rawValue: 1000) }
        constraints.forEach { $0.isActive = true }
    }
}
