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
        case .english:  return "Designed by: Thomassie Mangiok"
        case .french:   return "Conçu par: Thomassie Mangiok"
        }
    }
    
    var founded: String {
        switch self {
        case .inuit:    return "ᐆᒪ ᑮᓇᐅᔭᖃᑦᑎᓂᑯᖓ: ᐊᕙᑕᖅ ᐱᐅᓯᑐᖃᓕᕆᕕᒃ"
        case .english:  return "Funded by: Avataq Cultural Institute"
        case .french:   return "Financé par: L’Institut Culturel Avataq"
        }
    }
    
    var programmed: String {
        switch self {
        case .inuit:    return "ᐆᒪ ᓴᓇᔭᕕᓂᖓ: ᕉᒪᓐ ᑲᕕᓐᔅᑭ"
        case .english:  return "Programmed by: Roman Kavinskyi"
        case .french:   return "Programmé par: Roman Kavinskyi"
        }
    }
    
    var fontCredit: String {
        switch self {
        case .inuit:    return "ᐃᓕᓴᕐᓂᖅ ᖃᓂᐅᔮᕐᐯ Coppers and Brassesᑯᓐᓄ"
        case .english:  return "Ilisarniq font by Coppers and Brasses"
        case .french:   return "Police Ilisarniq par Coppers and Brasses"
        }
    }
}
