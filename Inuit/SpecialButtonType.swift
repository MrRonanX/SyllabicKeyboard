//
//  SpecialButtonType.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/23/22.
//

import Foundation
import UIKit

enum SpecialButtonType {
    
    case sectionOne(onTap: () -> Void),
         sectionTwo(onTap: () -> Void),
         sectionThree(onTap: () -> Void),
         sectionFour(onTap: () -> Void),
         numericSection(onTap: () -> Void),
         arrowRight(onTap: () -> Void),
         arrowLeft(onTap: () -> Void),
         delete(onTap: () -> Void),
         syllables(onTap: () -> Void, keyboardType: KeyboardType),
         twoDots(onTap: () -> Void, keyboardType: KeyboardType),
         enter(onTap: () -> Void),
         space(onTap: () -> Void),
         changeLanguage(onTap: () -> Void)
    
    var image: UIImage? {
        switch self {
        case .sectionOne:       return Images.arrowDown
        case .sectionTwo:       return Images.arrowUp
        case .sectionThree:     return Images.arrowRight
        case .sectionFour:      return Images.arrowLeft
        case .arrowRight:       return Images.forward
        case .arrowLeft:        return Images.backwards
        case .delete:           return Images.backspace
        case .changeLanguage:   return Images.world
        case .syllables(_, let keyboardType): return keyboardType.sectionImage
            
        default:                return nil
        }
    }
    
    var title: String? {
        switch self {
        case .numericSection:   return "1"
        case .syllables:        return "•"
        case .twoDots:          return "••"
        case .enter:            return "ᐊᑌ"
        case .space:            return "ᐅᖓᓯᓪᓕᑎᖅ"
        default:                return nil
        }
    }
    
    var imageColor: UIColor {
        if case .changeLanguage = self  { return .appGray }
        if case .arrowLeft = self       { return .black }
        if case .arrowRight = self      { return .black }
        if case .delete = self          { return .appGray }
        if case .space = self           { return .appGray}
        if case .enter = self           { return .appGray}
        return .white
    }
    
    var hasColoredBackground: Bool {
        switch self {
        case .sectionOne, .sectionTwo, .sectionThree, .sectionFour, .numericSection, .arrowRight, .arrowLeft, .syllables, .twoDots: return true
        default: return false
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .sectionOne:       return .systemBlack
        case .sectionTwo:       return .appBlue
        case .sectionThree:     return .appOrange
        case .sectionFour:      return .appGreen
        case .arrowRight:       return .appYellow
        case .arrowLeft:        return .appYellow
        case .numericSection:   return .appYellow
        case .delete, .changeLanguage, .enter, .space: return .systemWhite
        case .syllables(_, let keyboardType),
                .twoDots(_, let keyboardType): return keyboardType.backgroundColor
        }
    }
    
    var hasArrow: Bool {
        if case .arrowLeft  = self { return true }
        if case .arrowRight = self { return true }
        return false
    }
    
    func action() {
        switch self {
        case .sectionOne(let onTap),
                .sectionTwo(let onTap),
                .sectionThree(let onTap),
                .sectionFour(let onTap),
                .numericSection(let onTap),
                .arrowRight(let onTap),
                .arrowLeft(let onTap),
                .delete(let onTap),
                .syllables(let onTap, _),
                .twoDots(let onTap, _),
                .enter(let onTap),
                .space(let onTap),
                .changeLanguage(let onTap):
            onTap()
        }
    }
}
