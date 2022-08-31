//
//  KeyboardRowView.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/30/22.
//

import UIKit

final class KeyboardRowView: UIStackView {
    
    private var isIpad: Bool { UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad }
    private var keySpacing: CGFloat { isIpad ? 7.0 : 5.0 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    private func commonSetup() {
        distribution = .fillProportionally
        spacing = keySpacing
    }
}
