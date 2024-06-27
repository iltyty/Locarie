//
//  BusinessProfileDetailButton.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessProfileDetailButton: View {
  @Binding var presenting: Bool

  var body: some View {
    Button {
      withAnimation(.spring) {
        presenting.toggle()
      }
    } label: {
      Image("Chevron.Down")
        .resizable()
        .scaledToFit()
        .rotationEffect(presenting ? .degrees(-180) : .zero)
        .frame(width: 18, height: 18)
    }
    .buttonStyle(.plain)
  }
}
