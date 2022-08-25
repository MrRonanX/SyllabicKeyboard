//
//  ContentView.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/19/22.
//

import SwiftUI




struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(viewModel.selectedLanguage.mainTitle)
                    .font(.title2)
                    .bold()
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                VStack(alignment: .leading) {
                    Group {
                        Spacer()
                        Text(viewModel.selectedLanguage.installationTitle)
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                   
                    Spacer()
                    
                    Text(viewModel.selectedLanguage.settingsTitle)
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 10) {
                        VStack {
                            Text(viewModel.selectedLanguage.goToTitle)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("  ")
                            Text(viewModel.selectedLanguage.generalTitle)
                            Text(viewModel.selectedLanguage.keyboardTitle)
                            Text(viewModel.selectedLanguage.keyboardsTitle)
                        }
                    }
                    
                    Spacer()
                    Text(viewModel.selectedLanguage.addNewKeyboardTitle)
                    Spacer()
                    Text(viewModel.selectedLanguage.selectKeyboardTitle)
                    Spacer()
                }
                .padding(.horizontal)
                
                ButtonsView(viewModel: viewModel)
                
                NavigationLink("", isActive: $viewModel.navigationActive) { SyllabicCharactersView() }
            }
            .padding()
            .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

fileprivate struct ButtonsView: View {
    
    @ObservedObject var viewModel: ContentView.ViewModel
    
    var body: some View {
        VStack {
            LanguageButton(title: viewModel.selectedLanguage.buttonTitle, color: .green, action: { viewModel.navigationActive.toggle()})
            
            HStack(spacing: 10) {
                LanguageButton(title: "Syllabic", color: .black, action: viewModel.inuitSelected)
                LanguageButton(title: "English", color: .orange, action: viewModel.englishSelected)
                LanguageButton(title: "French", color: .black, action: viewModel.frenchSelected)
            }
        }
    }
}

fileprivate struct LanguageButton: View {
    
    var title: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
            
        }.background(color.cornerRadius(10))
    }
}






