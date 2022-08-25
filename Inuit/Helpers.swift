//
//  Helpers.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/23/22.
//

import UIKit
import SwiftUI

enum DeviceTypes {
    enum ScreenSize {
        static let width                = UIScreen.main.bounds.size.width
        static let height               = UIScreen.main.bounds.size.height
        static let maxLength            = max(ScreenSize.width, ScreenSize.height)
    }

    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    
    static var olderIphone: Bool {
        isiPhone8Standard || isiPhone8PlusStandard
    }
}

enum SpecialCharacters {
    static let filter = [
        ".", ",", "?", "!", ";", ":", "+", "-", "*", "/", "=", "%", "|", "≠", "≈", "≤", "≥", "<", ">", "°", "_", "^", "\\", "$", "¢", "@", "[", "]", "(", ")", "«", "»", "&", "{", "}", "#", ";", ":", "'", #"""#, "m", "g", "x", "y", "z", "•"
    ]
    
    static let numericFilter = [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    static let inuitCharacters = InuitCharacterSet.characters
    
    struct InuitCharacterSet: Identifiable {
        var id = UUID()
        var characters: [String]
        var color: Color
        
        static let characters = [
            Self(characters: ["ᐁ", "ᐯ", "ᑌ", "ᑫ", "ᒉ", "ᒣ", "ᓀ", "ᓭ", "ᓓ", "ᔦ", "ᕓ", "ᕂ", "ᙯ", "ᙰ"], color: .black),
            Self(characters: ["ᐃ", "ᐱ", "ᑎ", "ᑭ", "ᒋ", "ᒥ", "ᓂ", "ᓯ", "ᓕ", "ᔨ", "ᕕ", "ᕆ", "ᕿ", "ᖏ"], color: Color(uiColor: .appBlue)),
            Self(characters: ["ᐅ", "ᐳ", "ᑐ", "ᑯ", "ᒍ", "ᒧ", "ᓄ", "ᓱ", "ᓗ", "ᔪ", "ᕗ", "ᕈ", "ᖁ", "ᖑ"], color: Color(uiColor: .appOrange)),
            Self(characters: ["ᐊ", "ᐸ", "ᑕ", "ᑲ", "ᒐ", "ᒪ", "ᓇ", "ᓴ", "ᓚ", "ᔭ", "ᕙ", "ᕋ", "ᖃ", "ᖓ", "ᖠ", "ᖢ", "ᖤ"], color: Color(uiColor: .appGreen))
        ]
    }
}
