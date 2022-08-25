//
//  UIInputView + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/25/22.
//

import UIKit

extension UIInputView: UIInputViewAudioFeedback {

    public var enableInputClicksWhenVisible: Bool {
        get {
            return true
        }
    }

    func playInputClick​() {
        UIDevice.current.playInputClick()
    }
}
