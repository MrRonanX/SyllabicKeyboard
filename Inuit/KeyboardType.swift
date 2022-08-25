//
//  KeyboardType.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/19/22.
//

import Foundation
import UIKit

enum KeyboardType {
    case sectionOne, sectionTwo, sectionThree, sectionFour, numericSection
    
    var firstRowKeys: [String] {
        switch self {
        case .sectionOne:       return ["ᐁ", "ᐯ", "ᑌ", "ᑫ", "ᒉ", "ᒣ", "ᓀ"]
        case .sectionTwo:       return ["ᐃ", "ᐱ", "ᑎ", "ᑭ", "ᒋ", "ᒥ", "ᓂ"]
        case .sectionThree:     return ["ᐅ", "ᐳ", "ᑐ", "ᑯ", "ᒍ", "ᒧ", "ᓄ"]
        case .sectionFour:      return ["ᐊ", "ᐸ", "ᑕ", "ᑲ", "ᒐ", "ᒪ", "ᓇ"]
        case .numericSection:   return ["0", "1", "2", "3", "4"]
        }
    }

    var secondRowKeys: [String] {
        switch self {
        case .sectionOne:       return ["ᓭ", "ᓓ", "ᔦ", "ᕓ", "ᕂ", "ᙯ", "ᙰ"]
        case .sectionTwo:       return ["ᓯ", "ᓕ", "ᔨ", "ᕕ", "ᕆ", "ᕿ", "ᖏ"]
        case .sectionThree:     return ["ᓱ", "ᓗ", "ᔪ", "ᕗ", "ᕈ", "ᖁ", "ᖑ"]
        case .sectionFour:      return ["ᓴ", "ᓚ", "ᔭ", "ᕙ", "ᕋ", "ᖃ", "ᖓ"]
        case .numericSection:   return ["5", "6", "7", "8", "9"]
        }
    }
    
    var thirdRowKeys: [String] {
        let genericThirdRow = [".", ",", "?", "!", ";", ":"]
        let sectionFourRow = ["ᖠ", "ᖢ", "ᖤ", ".", ",", "?"]
        return self == .sectionFour ? sectionFourRow : genericThirdRow
    }
    
    var consonantsFirstRow: [String] {
        switch self {
        case .sectionOne:       return ["🌚", "🌝", "🌞", "🌟", "🌥", "🌧", "🌨"]
        case .sectionTwo:       return ["ᐄ", "ᐲ", "ᑏ", "ᑮ", "ᒌ", "ᒦ", "ᓃ"]
        case .sectionThree:     return ["ᐆ", "ᐴ", "ᑑ", "ᑰ", "ᒎ", "ᒨ", "ᓅ"]
        case .sectionFour:      return ["ᐋ", "ᐹ", "ᑖ", "ᑳ", "ᒑ", "ᒫ", "ᓈ"]
        case .numericSection:   return ["+", "-", "*", "/", "=", "%", "|"]
        }
    }
    
    var consonantsSecondRow: [String] {
        switch self {
        case .sectionOne:       return ["🌬", "🎉", "🍽", "🐕", "👋", "👍", "🧡"]
        case .sectionTwo:       return ["ᓰ", "ᓖ", "ᔩ", "ᕖ", "ᕇ", "ᖀ", "ᖏ"]
        case .sectionThree:     return ["ᓲ", "ᓘ", "ᔫ", "ᕘ", "ᕉ", "ᖂ", "ᖒ"]
        case .sectionFour:      return ["ᓵ", "ᓛ", "ᔮ", "ᕚ", "ᕌ", "ᖄ", "ᖔ"]
        case .numericSection:   return ["≠", "≈", "≤", "≥", "<", ">", "°"]
        }
    }
    
    var consonantsThirdRow: [String] {
        switch self {
        case .sectionOne:       return ["🙂", "🙁", "😢", "😍", "😘", "🤣"]
        case .sectionTwo:       return thirdRowKeys
        case .sectionThree:     return thirdRowKeys
        case .sectionFour:      return ["ᖡ", "ᖣ", "ᖥ", ".", ",", "?",]
        case .numericSection:   return ["_", "^", "\\", "$", "¢", "@"]
        }
    }
    
    var doubleDotsFirstRow: [String] {
        let generic = ["ᖖ", "ᑉ", "ᑦ", "ᒃ", "ᒡ", "ᒻ", "ᓐ", "ᕻ"]
        let numeric = ["[", "]", "(", ")", "«", "»", "&"]
        return self == .numericSection ? numeric : generic
    }
    
    var doubleDotsSecondRow: [String] {
        let generic = ["ᔅ", "ᓪ", "ᔾ", "ᕝ", "ᕐ", "ᖅ", "ᖕ", "ᖦ"]
        let numeric = ["{", "}", "#", ";", ":", "'", #"""#]
        return self == .numericSection ? numeric : generic
    }
    
    var doubleDotsThirdRow: [String] {
        let generic = [".", ",", "?", "!", ";", ":"]
        let numeric = ["m", "g", "x", "y", "z", "•"]
        return self == .numericSection ? numeric : generic
        
    }

    var backgroundColor: UIColor {
        switch self {
        case .sectionOne:       return .black
        case .sectionTwo:       return .appBlue
        case .sectionThree:     return .appOrange
        case .sectionFour:      return .appGreen
        case .numericSection:   return .appYellow
        }
    }
    
    var foregroundColor: UIColor {
        if self == .numericSection { return .label }
        return .white
    }
    
    func firstRow(_ consonantsActive: Bool, _ twoDotsActive: Bool) -> [String] {
        if twoDotsActive {
            return doubleDotsFirstRow
        }
        
        return consonantsActive ? consonantsFirstRow : firstRowKeys
    }
    
    func secondRow(_ consonantsActive: Bool, _ twoDotsActive: Bool) -> [String] {
        if twoDotsActive {
            return doubleDotsSecondRow
        }
        
        return consonantsActive ? consonantsSecondRow : secondRowKeys
    }
    
    func thirdRow(_ consonantsActive: Bool, _ twoDotsActive: Bool) -> [String] {
        if twoDotsActive {
            return doubleDotsThirdRow
        }
        
        return consonantsActive ? consonantsThirdRow : thirdRowKeys
    }
}
