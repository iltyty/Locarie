//
//  View+BottomDialog.swift
//  locarie
//
//  Created by qiuty on 18/06/2024.
//

import SwiftUI

extension View {
  func bottomDialog(
    isPresented: Binding<Bool>,
    onDismiss: @escaping () -> Void = {},
    @ViewBuilder content: @escaping () -> some View
  ) -> some View {
    sheet(isPresented: isPresented, onDismiss: onDismiss) {
      if #available(iOS 16.4, *) {
        sheetContent(content: content())
          .presentationCornerRadius(24)
      } else {
        sheetContent(content: content())
      }
    }
  }
}

private func sheetContent(content: some View) -> some View {
  ZStack(alignment: .top) {
    LocarieColor.greyMedium
    VStack(spacing: 18) {
      Capsule()
        .frame(width: 48, height: 6)
        .foregroundStyle(Color(hex: 0xD9D9D9))
        .padding(.top, 8)
      content
      Spacer()
    }
  }
  .ignoresSafeArea(edges: .bottom)
  .presentationDragIndicator(.hidden)
  .presentationDetents([.height(180)])
}

struct BottomDialogTestView: View {
  @State private var presenting = true

  var body: some View {
    Text("hello").bottomDialog(isPresented: $presenting) {
      VStack(spacing: 5) {
        bottomDialogButtonBuilder("OK") { print("OK") }
        bottomDialogButtonBuilder("Cancel") { print("Cancel") }
      }
      .padding(.horizontal, 16)
    }
  }
}

#Preview {
  BottomDialogTestView()
}
