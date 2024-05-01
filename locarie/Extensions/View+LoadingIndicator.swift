//
//  View+LoadingIndicator.swift
//  locarie
//
//  Created by qiuty on 11/04/2024.
//

import SwiftUI

extension View {
  func loadingIndicator(loading: Binding<Bool>) -> some View {
    ZStack {
      self.disabled(loading.wrappedValue)
      if loading.wrappedValue {
        LoadingIndicator()
      }
    }
  }
}

#Preview {
  Color.white.loadingIndicator(loading: .constant(true))
}
