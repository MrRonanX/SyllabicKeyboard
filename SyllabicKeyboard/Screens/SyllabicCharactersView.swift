//
//  SyllabicCharactersView.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/26/22.
//

import SwiftUI

struct SyllabicCharactersView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentView.ViewModel
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
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
    
    var backButton: some View {
        Button(action: dismissView, label: {
            HStack {
                Image(systemName: "chevron.left").font(.headline)
                Text(viewModel.selectedLanguage.backButtonTitle)
            }
        })
    }
    
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SyllabicCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        SyllabicCharactersView(viewModel: .init())
    }
}
