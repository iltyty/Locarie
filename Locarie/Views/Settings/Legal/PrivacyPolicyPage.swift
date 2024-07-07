//
//  PrivacyPolicyPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct PrivacyPolicyPage: View {
  @State private var loading = true

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Privacy Policy")
      ZStack {
        WebView(url: "https://www.locarie.com/privacy", loading: $loading)
          .ignoresSafeArea(edges: .bottom)
        if loading {
          ProgressView()
        }
      }
    }
  }
}

#Preview {
  PrivacyPolicyPage()
}
