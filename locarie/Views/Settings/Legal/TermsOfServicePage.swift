//
//  TermsOfServicePage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct TermsOfServicePage: View {
  @State private var loading = true

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Terms of Service")
      ZStack {
        WebView(url: "https://www.locarie.com", loading: $loading)
          .ignoresSafeArea(edges: .bottom)
        if loading {
          ProgressView()
        }
      }
    }
  }
}

#Preview {
  TermsOfServicePage()
}
