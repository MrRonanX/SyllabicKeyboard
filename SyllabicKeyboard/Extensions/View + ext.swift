//
//  View + ext.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 9/6/22.
//

import SwiftUI

extension View {
    var spacing: CGFloat {
        DeviceTypes.isIpod ? 10 : 20
    }
    
    var smallSpacing: CGFloat {
        spacing / 2
    }
}
