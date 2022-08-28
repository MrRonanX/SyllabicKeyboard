//
//  KeyboardButton.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/19/22.
//

import UIKit

class KeyboardButton: UIButton {
    
    var defaultBackgroundColor: UIColor = .systemWhite
    var highlightBackgroundColor: UIColor = .lightGray
    
    var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isHighlighted ? highlightBackgroundColor : defaultBackgroundColor
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -5, dy: -7).contains(point)
    }
    
    @objc private func buttonTapped() {
        action?()
    }
    
    func longTouchStarted() {
        defaultBackgroundColor = .lightGray
    }
    
    func longTouchEnded() {
        defaultBackgroundColor = .systemWhite
        backgroundColor = .systemWhite
    }
}


// MARK: - Private Methods
private extension KeyboardButton {
    func commonInit() {        
        layer.cornerRadius = 7.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.35
        
        imageView?.contentMode = .scaleAspectFit
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}
