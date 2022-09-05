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
    
    static var largeIpad: Bool {
        return isiPad && UIScreen.main.fixedCoordinateSpace.bounds.height > 1170
    }
}

enum SpecialCharacters {
    static let filter = [
        ".", ",", "?", "!", ";", ":", "+", "-", "*", "/", "=", "%", "|", "≠", "≈", "≤", "≥", "<", ">", "°", "_", "^", "\\", "√", "π", "@", "[", "]", "(", ")", "«", "»", "&", "{", "}", "#", "cm", "km", "'", #"""#, "m", "g", "x", "y", "z", "•"
    ]
    
    static let numericFilter = [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "$", "¢"]
    
    static let inuitCharacters = InuitCharacterSet.characters
    
    struct InuitCharacterSet: Identifiable {
        var id = UUID()
        var characters: [String]
        var color: Color
        static let someColor = Color(UIColor.label)
        static let characters = [
            Self(characters: ["ᐁ", "ᐯ", "ᑌ", "ᑫ", "ᒉ", "ᒣ", "ᓀ", "ᓭ", "ᓓ", "ᔦ", "ᕓ", "ᕂ", "ᙯ", "ᙰ"], color: Color(UIColor.label)),
            Self(characters: ["ᐃ", "ᐱ", "ᑎ", "ᑭ", "ᒋ", "ᒥ", "ᓂ", "ᓯ", "ᓕ", "ᔨ", "ᕕ", "ᕆ", "ᕿ", "ᖏ", "ᖠ"], color: Color(UIColor.appBlue)),
            Self(characters: ["ᐅ", "ᐳ", "ᑐ", "ᑯ", "ᒍ", "ᒧ", "ᓄ", "ᓱ", "ᓗ", "ᔪ", "ᕗ", "ᕈ", "ᖁ", "ᖑ", "ᖢ"], color: Color(UIColor.appOrange)),
            Self(characters: ["ᐊ", "ᐸ", "ᑕ", "ᑲ", "ᒐ", "ᒪ", "ᓇ", "ᓴ", "ᓚ", "ᔭ", "ᕙ", "ᕋ", "ᖃ", "ᖓ", "ᖤ"], color: Color(UIColor.appGreen))
        ]
    }
}
