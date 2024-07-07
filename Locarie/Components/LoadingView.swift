//
//  LoadingView.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import SwiftUI

struct LoadingView: View {
  @Binding var loading: Bool

  init(_ loading: Binding<Bool>) {
    _loading = loading
  }

  var body: some View {
    if loading {
      Color.black
        .opacity(GlobalConstants.loadingBgOpacity)
        .overlay {
          ProgressView()
        }
        .ignoresSafeArea()
    } else {
      EmptyView()
    }
  }
}

#Preview {
  LoadingView(.constant(true))
}
