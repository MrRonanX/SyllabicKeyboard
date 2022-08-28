//
//  ContentViewModel.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/26/22.
//

import SwiftUI

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var selectedLanguage: Localization = .english
        @Published var navigationActive = false
        
        
        func englishSelected() {
            selectedLanguage = .english
        }
        
        func inuitSelected() {
            selectedLanguage = .inuit
        }
        
        func frenchSelected() {
            selectedLanguage = .french
        }
        
        var font: Font {
            if selectedLanguage == .inuit { return Font.custom("Ilisarniq-Demi", size: 28) }
            return .title
        }
        
        var generalSizeFont: Font {
            if selectedLanguage == .inuit { return Font.custom("Ilisarniq-Demi", size: 17) }
            return .body
        }
    }
}
