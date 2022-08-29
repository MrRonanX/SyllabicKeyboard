//
//  CreditPage.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/29/22.
//

import SwiftUI

struct CreditPage: View {
    
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
            
            WebView(url: URL(string: "https://en.wikipedia.org/wiki/Inuktitut")!)
        }
        .navigationTitle(viewModel.selectedLanguage.credit)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreditPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreditPage(viewModel: ContentView.ViewModel())
        }
    }
}


