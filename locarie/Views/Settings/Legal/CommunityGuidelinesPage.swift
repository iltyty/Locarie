//
//  CommunityGuidelinesPage.swift
//  locarie
//
//  Created by qiuty on 06/07/2024.
//

import SwiftUI

struct CommunityGuidelinesPage: View {
  @State private var loading = true

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Community Guidelines")
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
  CommunityGuidelinesPage()
}
