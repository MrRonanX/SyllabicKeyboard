//
//  Localization.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/26/22.
//

import Foundation

enum Localization {
    case inuit, english, french
    
    var mainTitle: String {
        switch self {
        case .inuit: return "ᐃᓄᐃᑦ ᓇᕿᑕᕋᖓ"
        case .english: return "Inuktitut Keyboard"
        case .french: return "Clavier en Inuktitut"
        }
    }
    
    var installationTitle: String {
        switch self {
        case .inuit: return "ᒪᓕᒐᖅ ᓄᐃᑦᓯᕈᑎᒃ"
        case .english: return "Installation instruction"
        case .french: return "Instructions d'installation"
        }
    }
    
    var settingsTitle: String {
        switch self {
        case .inuit: return "• ᐊᒻᒪᓗᒍ"
        case .english: return "• Open settings"
        case .french: return "• Ouvrir les paramètres"
        }
    }
    
    var goToTitle: String {
        switch self {
        case .inuit: return "• ᒪᐅᖕᖓᓗᑎᑦ"
        case .english: return "• Go to"
        case .french: return "• Sous"
        }
    }
    
    var generalTitle: String {
        switch self {
        case .inuit, .english: return "> General"
        case .french: return "> Général"
        }
    }
    
    var keyboardTitle: String {
        switch self {
        case .inuit, .english: return "> Keyboard"
        case .french: return "> Clavier"
        }
    }
    
    var keyboardsTitle: String {
        switch self {
        case .inuit, .english:  return "> Keyboards"
        case .french: return "> Claviers"
        }
    }
      
    
    var addNewKeyboardTitle: String {
        switch self {
        case .inuit: return "• ᓇᕐᓂᓗᒍ Add new keyboard"
        case .english: return "• Click Add new keyboard"
        case .french: return "• Ajouter un nouveau clavier"
        }
    }
    
    var selectKeyboardTitle: String {
        switch self {
        case .inuit: return "• ᓇᕐᓂᓗᒍ Inuit keyboard"
        case .english: return "• Select Inuit keyboard"
        case .french: return "• Choisissez Inuit keyboard"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .inuit: return "ᖃᓂᐅᔮᕐᐯᑎᑑᕐᑐᑦ ᓄᐃᑎᓗᒋᑦ"
        case .english: return "View syllabic characters"
        case .french: return "Afficher les caractères syllabiques"
        }
    }
    
    var credit: String {
        switch self {
        case .inuit:    return "ᓄᐃᑎᓯᒪᔪᑦ"
        case .english:  return "Credit"
        case .french:   return "Crédit"
        }
    }
    
    var designed: String {
        switch self {
        case .inuit:    return "ᐆᒪ ᐱᒍᓐᓇᓯᑎᑕᕕᓂᖓ: ᑑᒪᓯ ᒪᖏᐅᖅ"
        case .english:  return "Designed by Thomassie Mangiok"
        case .french:   return "Conçu par Thomassie Mangiok"
        }
    }
    
    var founded: String {
        switch self {
        case .inuit:    return "ᐆᒪ ᑮᓇᐅᔭᖃᑦᑎᓂᑯᖓ: ᐊᕙᑕᖅ ᐱᐅᓯᑐᖃᓕᕆᕕᒃ"
        case .english:  return "Funded by Avataq Cultural Institute"
        case .french:   return "Financé par L’Institut Culturel Avataq"
        }
    }
    
    var programmed: String {
        switch self {
        case .inuit:    return "ᐆᒪ ᓴᓇᔭᕕᓂᖓ: ᕉᒪᓐ ᑲᕕᓐᔅᑭ"
        case .english:  return "Programmed by Roman Kavinskyi"
        case .french:   return "Programmé par Roman Kavinskyi"
        }
    }
    
    var fontCredit: String {
        switch self {
        case .inuit:    return "ᐃᓕᓴᕐᓂᖅ ᖃᓂᐅᔮᕐᐯ Coppers and Brassesᑯᓐᓄ"
        case .english:  return "Ilisarniq typeface created by Coppers and Brasses"
        case .french:   return "Police de caractères Ilisarniq par Coppers and Brasses"
        }
    }
    
    private var englishUrl: String { "https://en.wikipedia.org/wiki/Inuktitut" }
    
    var wikiURL: String {
        switch self {
        case .inuit:    return "https://iu.wikipedia.org/wiki/ᐃᓄᒃᑎᑐᑦ".encodeSpecialCharacters() ?? englishUrl
        case .english:  return englishUrl
        case .french:   return "https://fr.wikipedia.org/wiki/Inuktitut"
        }
    }
    
    var alertTitle: String {
        switch self {
        case .inuit:    return ""
        case .english:  return "We need your consent"
        case .french:   return ""
        }
    }
    
    var alertMessage: String {
        switch self {
        case .inuit:    return #""ᐃᓕᓐᓂᑐᐊ ᐱᒍᑦᔨᔪᒃ" ᐊᐅᓚᑎᑐᐊᒍᕕᐅᒃ, ᐊᓪᓚᒐᔪᓲᑎᑦ ᖃᕆᑕᐅᔮᕈᓐᓄᑦ ᓄᐊᑕᐅᔪᑦ ᐊᓪᓚᓕᕈᕕᑦ ᐅᖃᐅᓰᑦ ᐊᓪᓚᓲᑎᑦ ᓇᕐᓂᓗᒋᑦ ᓄᐃᑎᕇᕈᓐᓇᖃᑦᑕᕋᔭᕋᕕᒋᑦ. ᐅᖃᐅᓰᑦ ᓄᐊᑕᐅᒪᔪᑦ ᖃᕆᑕᐅᔮᕈᑉᐱᑦ ᐃᓗᐊᓃᑐᐃᓐᓇᓚᖓᔪᑦ ᓄᖑᑎᕈᓐᓇᓱᒋᓪᓗ. ᐃᓕᓐᓂᑐᐊ ᐱᒍᑦᔨᔪᒃ ᓄᕐᖃᑎᒍᓐᓇᑌᑦ"#
        case .english:  return #"When "Personalized suggestions" enabled algorithms track what vocabulary you use and on what frequency. Algorithm provides suggestions based on how often the word was used by you. The algorithm is executed on the device and all the information is stored on locally on the device. You can disable suggestions or delete all collected data from this application"#
        case .french:   return #"Lorsque les "Suggestions personnalisées" sont activées, les algorithmes suivent le vocabulaire que vous utilisez et à quelle fréquence. L'algorithme fournit des suggestions en fonction de la fréquence à laquelle vous avez utilisé le mot. L'algorithme est exécuté sur l'appareil et toutes les informations sont stockées localement sur l'appareil. Vous pouvez désactiver les suggestions ou supprimer toutes les données collectées de cette application"#
        }
    }
    
    var alertOKButton: String {
        switch self {
        case .inuit:    return "ᐱᕈᓐᓇᓯᑎᓗᒍ"
        case .english:  return "Enable"
        case .french:   return "Activer"
        }
    }
    
    var alertCancelButton: String {
        switch self {
        case .inuit:    return "ᖁᔭᓇ"
        case .english:  return "Cancel"
        case .french:   return "Annuler"
        }
    }
    
    var deletionConfirmationTitle: String {
        switch self {
        case .inuit:    return "ᐊᓪᓚᑕᐅᒪᔪᓕᒫᑦ ᓄᖑᑎᓪᓕ"
        case .english:  return "Delete All Data"
        case .french:   return "Supprimer toutes les données"
        }
    }
    
    var deletionConfirmationMessage: String {
        switch self {
        case .inuit:    return "ᐊᑑᑎᒍᕕᐅ ᐅᑎᕆᐊᕐᖃᔭᓚᖓᖕᖏᑐᑎᑦ"
        case .english:  return "This action is irreversible"
        case .french:   return "Cette action est irréversible"
        }
    }
    
    var deleteButtonTitle: String {
        switch self {
        case .inuit:    return "ᓄᖑᑎᕆᐅᑎᒃ"
        case .english:  return "Delete"
        case .french:   return "Effacer"
        }
    }
    
    var successfulDeletionTitle: String {
        switch self {
        case .inuit:    return "ᐊᓪᓚᑕᐅᒪᔪᓕᒫᑦ ᓄᖑᑎᓯᒪᔪᑦ"
        case .english:  return "All data has been removed"
        case .french:   return "Toutes les données ont été supprimées"
        }
    }
    
    var toggleTitle: String {
        switch self {
        case .inuit:    return "ᐃᓕᓐᓂᑐᐊ ᐱᒍᑦᔨᔪᒃ ᐊᐅᓚᑎᓗᒍ"
        case .english:  return "Enable personalized suggestions"
        case .french:   return "Activer les suggestions personnalisées"
        }
    }
    
    var deleteDataButtonTitle: String {
        switch self {
        case .inuit:    return "ᐊᓪᓚᓯᒪᔪᑦ ᓄᐊᑕᐅᒪᔪᑦ ᓄᖑᑎᓪᓕ"
        case .english:  return "Delete collected data"
        case .french:   return "Supprimer les données collectées"
        }
    }
}

