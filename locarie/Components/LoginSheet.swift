//
//  LoginSheet.swift
//  locarie
//
//  Created by qiuty on 06/07/2024.
//

import SwiftUI

struct LoginSheet: View {
  @Binding var isPresented: Bool

  var body: some View {
    VStack(spacing: 0) {
      Capsule()
        .frame(width: 48, height: 6)
        .foregroundStyle(LocarieColor.greyMedium)
        .padding(.top, 8)
        .padding(.bottom, 34)
      Text("Sign in")
        .fontWeight(.bold)
        .foregroundStyle(LocarieColor.black)
        .frame(width: 290, height: 48)
        .background {
          Capsule()
            .fill(.white)
            .shadow(color: LocarieColor.black.opacity(0.25), radius: 2, x: 0.25, y: 0.25)
        }
        .onTapGesture {
          isPresented = false
          Router.shared.navigate(to: Router.Destination.login)
        }
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  VStack {
    Spacer()
    LoginSheet(isPresented: .constant(true))
  }
  .ignoresSafeArea(edges: .bottom)
}
