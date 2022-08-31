//
//  AlertItem.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/31/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    var alert: Alert {
        guard let secondaryButton = secondaryButton else {
            return Alert(title: title, message: message, dismissButton: primaryButton)
        }
        
        return Alert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
    }
    
    let id = UUID()
    let title: Text
    let message: Text?
    let primaryButton: Alert.Button
    var secondaryButton: Alert.Button? = nil
}

enum AlertContext {
    static func inputCollectionConsentAlert(for language: Localization, completion: @escaping () -> Void) -> AlertItem {
        AlertItem(title: Text(language.alertTitle), message: Text(language.alertMessage), primaryButton: .default(Text(language.alertOKButton), action: completion), secondaryButton: .cancel(Text(language.alertCancelButton)))
    }
    
    static func deletionConfirmationAlert(for language: Localization, completion: @escaping () -> Void) -> AlertItem {
        AlertItem(title: Text(language.deletionConfirmationTitle), message: Text(language.deletionConfirmationMessage), primaryButton: .destructive(Text(language.deleteButtonTitle), action: completion), secondaryButton: .cancel(Text(language.alertCancelButton)))
    }
    
    static func successfulDeletionAlert(for language: Localization) -> AlertItem {
        AlertItem(title: Text(language.successfulDeletionTitle), message: nil, primaryButton: .default(Text(language.alertOKButton)), secondaryButton: nil)
    }
}
