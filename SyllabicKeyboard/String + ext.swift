//
//  String + ext.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/30/22.
//

import Foundation

extension String {
    func encodeSpecialCharacters() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}
