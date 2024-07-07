//
//  WebView.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let url: String
  @Binding var loading: Bool

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> WKWebView {
    let wkwebView = WKWebView()
    wkwebView.navigationDelegate = context.coordinator
    wkwebView.load(URLRequest(url: URL(string: url)!))
    return wkwebView
  }

  func updateUIView(_: WKWebView, context _: Context) {}

  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView

    init(_ parent: WebView) { self.parent = parent }

    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
      parent.loading = true
    }

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
      parent.loading = false
    }
  }
}
