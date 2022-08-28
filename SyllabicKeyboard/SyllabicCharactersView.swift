//
//  SyllabicCharactersView.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/26/22.
//

import SwiftUI

struct SyllabicCharactersView: View {
    
    @State var columns = SpecialCharacters.inuitCharacters
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(columns) { row in
                VStack(spacing: 9) {
                    ForEach(row.characters, id:\.self) { character in
                        Text(character)
                            .font(Font.custom("Ilisarniq-Demi", size: 22))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(row.color)
            }
        }
        
        
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SyllabicCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        SyllabicCharactersView()
    }
}
