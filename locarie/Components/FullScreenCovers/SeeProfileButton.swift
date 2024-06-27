//
//  SeeProfileButton.swift
//  locarie
//
//  Created by qiuty on 24/06/2024.
//

import SwiftUI

struct SeeProfileButton: View {
  var body: some View {
    Text("See profile")
      .foregroundStyle(.white)
      .padding(.horizontal, 24)
      .padding(.vertical, 10)
      .background {
        Capsule().fill(LocarieColor.primary).shadow(radius: 2)
      }
  }
}

#Preview {
  SeeProfileButton()
}
