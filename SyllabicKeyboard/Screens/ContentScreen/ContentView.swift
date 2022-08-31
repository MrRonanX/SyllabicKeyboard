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
            VStack(alignment: alignment, spacing: 20) {
                mainTitle
                installationInstructions
                suggestionsSwitch
//                    .alignmentGuide(., computeValue: <#T##(ViewDimensions) -> CGFloat#>)
                Spacer()
                
                
                
                ButtonsView(viewModel: viewModel)
                NavigationLink(isActive: $viewModel.navigationActive, destination: { SyllabicCharactersView() }, label: { EmptyView() })
                
            }
            .onAppear(perform: viewModel.setInitialValue)
//            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationBarHidden(true)
            .alert(item: $viewModel.alert) { $0.alert }
        }
        .navigationViewStyle(.stack)
    }
    
    var alignment: HorizontalAlignment {
        DeviceTypes.isiPad ? .center : .leading
    }
    
    var mainTitle: some View {
        ZStack {
            Text(viewModel.selectedLanguage.mainTitle)
                .font(viewModel.font)
                .bold()
//                .frame(maxWidth: .infinity, alignment: .center)
            
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
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.selectedLanguage.installationTitle)
                .font(viewModel.font)
                .foregroundColor(.blue)
            
            Text(viewModel.selectedLanguage.settingsTitle)
                .font(viewModel.generalSizeFont)
            
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
            .font(viewModel.generalSizeFont)
            
            Text(viewModel.selectedLanguage.addNewKeyboardTitle)
                .font(viewModel.generalSizeFont)
            Text(viewModel.selectedLanguage.selectKeyboardTitle)
                .font(viewModel.generalSizeFont)
        }
        .padding(.horizontal)
    }
    
    var suggestionsSwitch: some View {
        VStack(alignment: .leading) {
            Toggle("Enable personalized suggestions", isOn: $viewModel.suggestionsToggle)
            if viewModel.dictionaryHasSuggestions {
                Button("Delete collected data", action: viewModel.deleteButtonTapped)
            }
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
                .frame(maxWidth: .infinity)
                .padding()
            
        }.background(color.cornerRadius(10))
    }
    
    var textColor: Color {
        colorScheme == .dark ? .black : .white
    }
}






