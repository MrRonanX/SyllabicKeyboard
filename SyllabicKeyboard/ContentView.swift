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
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.selectedLanguage.mainTitle)
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        
                        Text(viewModel.selectedLanguage.installationTitle)
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                   
                    
                    
                    Text(viewModel.selectedLanguage.settingsTitle)
                    
                    
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
                    
                    
                    Text(viewModel.selectedLanguage.addNewKeyboardTitle)
                    
                    Text(viewModel.selectedLanguage.selectKeyboardTitle)
                }
                .padding(.horizontal)
                Spacer()
                
                ButtonsView(viewModel: viewModel)
                NavigationLink(isActive: $viewModel.navigationActive, destination: { SyllabicCharactersView() }, label: { EmptyView() })

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
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ContentView.ViewModel
    
    var body: some View {
        VStack {
            LanguageButton(title: viewModel.selectedLanguage.buttonTitle, color: .green, action: { viewModel.navigationActive.toggle()})
            
            HStack(spacing: 10) {
                LanguageButton(title: "Syllabic", color: syllabicColor, action: viewModel.inuitSelected)
                LanguageButton(title: "English", color: englishColor, action: viewModel.englishSelected)
                LanguageButton(title: "French", color: frenchColor, action: viewModel.frenchSelected)
            }
        }
    }
    
    private var buttonColor: Color {
        
        colorScheme == .dark ? .white : Color(uiColor: .systemBlack)
    }
    
    private var syllabicColor: Color {
        viewModel.selectedLanguage == .inuit ? .orange : buttonColor
    }
    
    private var englishColor: Color {
        viewModel.selectedLanguage == .english ? .orange : buttonColor
    }
    
    private var frenchColor: Color {
        viewModel.selectedLanguage == .french ? .orange : buttonColor
    }
}

fileprivate struct LanguageButton: View {
    
    @Environment(\.colorScheme) var colorScheme

    var title: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding()
            
        }.background(color.cornerRadius(10))
    }
    
    var textColor: Color {
        colorScheme == .dark ? .black : .white
    }
}






