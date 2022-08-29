//
//  WebView.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/29/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    @State var url: URL

    func makeUIView(context: Context) -> WKWebView { WKWebView() }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
