//
//  UIColor + ext.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/24/22.
//

import Foundation
import UIKit

extension UIColor {
    
    /**This returns the RGB Color by taking Parameters Red, Green and Blue Values*/
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static func colorFromHexValue(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.magenta
        }
        
        var rgb: UInt64 = 0
        Scanner.init(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
    static var systemBlack = colorFromHexValue("121212")
    
    static let appGray : UIColor = {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return colorFromHexValue("464646")
            }
        }
    }()
    
    static var systemWhite: UIColor = {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return rgbColor(red: 106, green: 106, blue: 106)
            } else {
                return .white
            }
        }
    }()
    
    static var appBlue: UIColor = {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colorFromHexValue("2a8ca7")
            } else {
                return colorFromHexValue("1a95b7")
            }
        }
    }()
    
    static var appOrange: UIColor = {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colorFromHexValue("d36b37")
            } else {
                return colorFromHexValue("e66523")
            }
        }
    }()
    
    static var appGreen: UIColor = {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colorFromHexValue("84b74e")
            } else {
                return colorFromHexValue("85c441")
            }
        }
    }()
    
    static var appYellow: UIColor = {
        return UIColor { traitCollection -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return colorFromHexValue("dec252")
            } else {
                return colorFromHexValue("efcc41")
            }
        }
    }()
}
