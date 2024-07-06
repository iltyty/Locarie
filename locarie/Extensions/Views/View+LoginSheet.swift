//
//  View+LoginSheet.swift
//  locarie
//
//  Created by qiuty on 06/07/2024.
//

import SwiftUI

extension View {
  @ViewBuilder
  func loginSheet(isPresented: Binding<Bool>) -> some View {
    sheet(isPresented: isPresented) {
      if #available(iOS 16.4, *) {
        sheetContent(isPresented: isPresented)
          .presentationCornerRadius(24)
          .presentationBackground {
            LinearGradient(
              colors: [LocarieColor.primary, Color.white], startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
          }
      } else {
        sheetContent(isPresented: isPresented)
          .background {
            LinearGradient(
              colors: [LocarieColor.primary, Color.white], startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
          }
      }
    }
  }
}

private func sheetContent(isPresented: Binding<Bool>) -> some View {
  LoginSheet(isPresented: isPresented)
    .presentationDragIndicator(.hidden)
    .presentationDetents([.height(180)])
}

private struct LoginSheetTestView: View {
  @State private var isPresented = true

  var body: some View {
    Text("hello")
      .loginSheet(isPresented: $isPresented)
  }
}

#Preview { LoginSheetTestView() }
