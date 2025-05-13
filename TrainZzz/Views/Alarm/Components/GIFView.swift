//
//  GIFView.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//

import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    let gifName = "alarm_arrival"
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifData = try? Data(contentsOf: URL(fileURLWithPath: path))
            uiView.load(gifData ?? Data(), mimeType: "image/gif", characterEncodingName: "", baseURL: URL(fileURLWithPath: path))
        }
    }
}
