//
//  View+BottomDialog.swift
//  locarie
//
//  Created by qiuty on 18/06/2024.
//

import SwiftUI

extension View {
  func bottomDialog(presenting: Binding<Bool>, @ViewBuilder content: () -> some View) -> some View {
    ZStack(alignment: .bottom) {
      self
      if presenting.wrappedValue {
        Color.black.opacity(0.2)
        VStack(spacing: 0) {
          Capsule()
            .frame(width: 48, height: 6)
            .foregroundStyle(Color(hex: 0xD9D9D9))
            .padding(.top, 6)
            .padding(.bottom, 16)
          content()
        }
        .frame(maxWidth: .infinity)
        .background {
          UnevenRoundedRectangle(topLeadingRadius: Constants.cornerRadius, topTrailingRadius: Constants.cornerRadius)
            .fill(LocarieColor.greyMedium)
        }
      }
    }
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 24
}

struct BottomDialogTestView: View {
  @State private var presenting = true

  var body: some View {
    Text("hello")
      .bottomDialog(presenting: $presenting) {
        Button("asdf") {
          print("d")
        }
      }
  }
}

#Preview {
  BottomDialogTestView()
}
