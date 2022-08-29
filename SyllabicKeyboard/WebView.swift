//
//  WebView.swift
//  SyllabicKeyboard
//
//  Created by Roman Kavinskyi on 8/29/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    @State var urlString: String

    func makeUIView(context: Context) -> WKWebView { WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1)) }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
