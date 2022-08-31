//
//  SuggestionsCore.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/30/22.
//

import Foundation

final class SuggestionCore {
    
    private var defaults    = UserDefaults(suiteName: Keys.appGroup)
    private var allSuggestions = [String: Int]()
    
    private var currentSessionSuggestions = [String: Int]()
    
    deinit {
        saveLocalData()
    }
    
    init() {
        suggestionsActive = defaults?.bool(forKey: Keys.suggestionsActivated) ?? false
        if suggestionsActive { loadSuggestions() }
    }
    
    let suggestionsActive: Bool
    
    private func loadSuggestions() {
        allSuggestions = SuggestionsPersistenceManager.shared.getSuggestionsList()
    }

    func provideSuggestions(for word: String) -> [String] {
        let allSuggestions = allSuggestions.filter { $0.key.contains(word) && $0.value >= 3 }.sorted { $0.value > $1.value }
        
        return  Array(allSuggestions.prefix(3).map { $0.key } )
    }
    
    func wordTyped(word: String) {
        guard suggestionsActive, !word.isEmpty else { return }
        let value = currentSessionSuggestions[word] ?? 0
        currentSessionSuggestions[word] = value + 1
     }
    
    private func mergeRecentSuggestionsIntoLocal() {
        currentSessionSuggestions.forEach {
            let value = allSuggestions[$0.key] ?? 0
            allSuggestions[$0.key] = value + $0.value
        }
        
        SuggestionsPersistenceManager.shared.saveSuggestions(list: allSuggestions)
    }
    
    private func saveLocalData() {
        guard suggestionsActive else { return }
        mergeRecentSuggestionsIntoLocal()
        defaults?.set(!allSuggestions.isEmpty, forKey: Keys.dictionaryHasSuggestions)
    }
}
