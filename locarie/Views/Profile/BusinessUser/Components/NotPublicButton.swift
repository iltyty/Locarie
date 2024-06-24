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
      .frame(width: 18, height: 18)
      .frame(width: 40, height: 40)
      .background {
        Circle().fill(LocarieColor.primary)
      }
  }
}

#Preview {
  NotPublicButton()
}
