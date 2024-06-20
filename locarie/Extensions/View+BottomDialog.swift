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
  ZStack {
    LocarieColor.greyMedium
    VStack(spacing: 16) {
      Capsule()
        .frame(width: 48, height: 6)
        .foregroundStyle(Color(hex: 0xD9D9D9))
        .padding(.top, 6)
      content
      Spacer()
    }
  }
  .ignoresSafeArea(edges: .bottom)
  .presentationDragIndicator(.hidden)
  .presentationDetents([.height(150)])
}

struct BottomDialogTestView: View {
  @State private var presenting = true

  var body: some View {
    Text("hello")
      .bottomDialog(isPresented: $presenting) {
        VStack(spacing: 5) {
          sheetButtonBuilder("OK") {
            print("OK")
          }
          sheetButtonBuilder("Cancel") {
            print("Cancel")
          }
        }
        .padding(.horizontal, 16)
      }
  }

  private func sheetButtonBuilder(_ title: String, action: @escaping () -> Void) -> some View {
    Text(title)
      .fontWeight(.bold)
      .frame(height: 48)
      .frame(maxWidth: .infinity)
      .background {
        RoundedRectangle(cornerRadius: 30).fill(.white).frame(maxWidth: .infinity)
      }
      .onTapGesture {
        action()
      }
  }
}

#Preview {
  BottomDialogTestView()
}
