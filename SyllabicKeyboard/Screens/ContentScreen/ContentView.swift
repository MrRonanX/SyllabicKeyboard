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
            ZStack(alignment: alignment) {
                VStack(alignment: .leading, spacing: spacing) {
                    mainTitle
                    installationInstructions
                    suggestionsSwitch
                    Spacer()
            }
                .frame(width: DeviceTypes.isiPad ? 320 : nil)
                VStack {
                    Spacer()
                    ButtonsView(viewModel: viewModel)
                    NavigationLink(isActive: $viewModel.navigationActive, destination: { SyllabicCharactersView(viewModel: viewModel) }, label: { EmptyView() })
                }
            }
            .onAppear(perform: viewModel.setInitialValue)
            .padding()
            .navigationBarHidden(true)
            .alert(item: $viewModel.alert) { $0.alert }
        }
        .navigationViewStyle(.stack)
    }
    
    var alignment: Alignment {
        DeviceTypes.isiPad ? .center : .leading
    }
    
    var mainTitle: some View {
        ZStack {
            Text(viewModel.selectedLanguage.mainTitle)
                .font(viewModel.font)
                .bold()
            
            HStack {
                Spacer()
                NavigationLink {
                    CreditPage(viewModel: viewModel)
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
    
    var installationInstructions: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(viewModel.selectedLanguage.installationTitle)
                .font(viewModel.font)
                .foregroundColor(.blue)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(viewModel.selectedLanguage.settingsTitle)
                .font(viewModel.generalSizeFont)
            
            HStack(alignment: .top, spacing: 10) {
                VStack {
                    Text(viewModel.selectedLanguage.goToTitle)
                }
                
                VStack(alignment: .leading, spacing: smallSpacing) {
                    Text("  ")
                    Text(viewModel.selectedLanguage.generalTitle)
                    Text(viewModel.selectedLanguage.keyboardTitle)
                    Text(viewModel.selectedLanguage.keyboardsTitle)
                }
            }
            .font(viewModel.generalSizeFont)
            
            Text(viewModel.selectedLanguage.addNewKeyboardTitle)
                .font(viewModel.generalSizeFont)
            Text(viewModel.selectedLanguage.selectKeyboardTitle)
                .font(viewModel.generalSizeFont)
        }
        .padding(.horizontal)
    }
    
    var suggestionsSwitch: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: spacing) {
                Text(viewModel.selectedLanguage.toggleTitle)
                if viewModel.dictionaryHasSuggestions {
                    Button(viewModel.selectedLanguage.deleteButtonTitle, action: viewModel.deleteButtonTapped)
                }
            }
            Spacer()
            Toggle("", isOn: $viewModel.suggestionsToggle)
                .frame(width: 50)
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
                LanguageButton(title: "ᐃᓄᒃᑎᑐᑦ", color: syllabicColor, action: viewModel.inuitSelected)
                    .font(Font.custom("Ilisarniq-Demi", size: 17))
                LanguageButton(title: "English", color: englishColor, action: viewModel.englishSelected)
                    .font(.headline)
                LanguageButton(title: "Français", color: frenchColor, action: viewModel.frenchSelected)
                    .font(.headline)
            }
            
        }
    }
    
    private var buttonColor: Color {
        colorScheme == .dark ? .white : Color(UIColor.systemBlack)
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
                .foregroundColor(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
                .padding()
            
        }.background(color.cornerRadius(10))
    }
    
    var textColor: Color {
        colorScheme == .dark ? .black : .white
    }
}






