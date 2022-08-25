//
//  ContentViewModel.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/26/22.
//

import Foundation

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
    }
}
