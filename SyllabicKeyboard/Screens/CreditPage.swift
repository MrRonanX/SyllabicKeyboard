//
//  CreditPage.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/29/22.
//

import SwiftUI

struct CreditPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentView.ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 20 ) {
                Text(viewModel.selectedLanguage.founded)
                Text(viewModel.selectedLanguage.designed)
                Text(viewModel.selectedLanguage.programmed)
                Text(viewModel.selectedLanguage.fontCredit)
            }
            .font(viewModel.generalSizeFont)
            .padding()
            
            WebView(urlString: viewModel.selectedLanguage.wikiURL)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(viewModel.selectedLanguage.credit)
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

struct CreditPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreditPage(viewModel: ContentView.ViewModel())
        }
    }
}


