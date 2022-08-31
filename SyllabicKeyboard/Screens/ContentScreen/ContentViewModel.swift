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
        @Published var suggestionsToggle = false {
            didSet {
                switchTapped()
            }
        }
        @Published var consentGiven = false
        @Published var alert: AlertItem?
        @Published var dictionaryHasSuggestions = false
        
        var defaults: UserDefaults?
        
        init() {
            defaults = UserDefaults(suiteName: Keys.appGroup)
        }
        
        func setInitialValue() {
            consentGiven = defaults?.bool(forKey: Keys.suggestionsActivated) ?? false
            suggestionsToggle = defaults?.bool(forKey: Keys.suggestionsActivated) ?? false
            dictionaryHasSuggestions = defaults?.bool(forKey: Keys.dictionaryHasSuggestions) ?? false
        }
        
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
        
        private func suggestionsEnabled() {
            consentGiven = true
            defaults?.set(consentGiven, forKey: Keys.suggestionsActivated)
        }
        
        // MARK: - Suggestions Permission Management
        
        private func switchTapped() {
            if suggestionsToggle && !consentGiven {
                alert = AlertContext.inputCollectionConsentAlert(for: selectedLanguage, completion: suggestionsEnabled)
                
            } else if !suggestionsToggle && consentGiven {
                consentGiven = false
                defaults?.set(false, forKey: Keys.suggestionsActivated)
            }
            
        }
        
        func deleteButtonTapped() {
            alert = AlertContext.deletionConfirmationAlert(for: selectedLanguage, completion: deleteCollectedData)
        }
        
        private func deleteCollectedData() {
            defaults?.set(nil, forKey: Keys.suggestionsDictionary)
            defaults?.set(false, forKey: Keys.dictionaryHasSuggestions)
            dictionaryHasSuggestions = false
            
            alert = AlertContext.successfulDeletionAlert(for: selectedLanguage)
        }
    }
}
