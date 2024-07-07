//
//  NotPublicButton.swift
//  locarie
//
//  Created by qiuty on 24/06/2024.
//

import SwiftUI

struct NotPublicButton: View {
  var body: some View {
    Image("Exclamationmark")
      .resizable()
      .scaledToFit()
      .frame(size: 18)
      .frame(size: 40)
      .background {
        Circle().fill(LocarieColor.primary)
      }
  }
}

#Preview {
  NotPublicButton()
}
