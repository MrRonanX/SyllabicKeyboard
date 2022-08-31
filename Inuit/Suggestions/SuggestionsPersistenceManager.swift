//
//  SuggestionsPersistenceManager.swift
//  Inuit
//
//  Created by Roman Kavinskyi on 8/31/22.
//

import Foundation

final class SuggestionsPersistenceManager {
    
    static let shared = SuggestionsPersistenceManager()
    
    private init() {}
    
    private var defaults = UserDefaults(suiteName: Keys.appGroup)
    
    func getSuggestionsList() -> [String: Int] {
        
        guard let defaults = defaults, let suggestionData = defaults.object(forKey: Keys.suggestionsDictionary) as? Data else { return [:] }
        
        do {
            let list = try JSONDecoder().decode([String: Int].self, from: suggestionData)
            return list
        } catch {
            return [:]
        }
    }
    
    func saveSuggestions(list: [String: Int]) {
        guard let defaults = defaults else { return }
        do {
            let encodedList = try JSONEncoder().encode(list)
            defaults.set(encodedList, forKey: Keys.suggestionsDictionary)
            
        } catch { }
    }
}
