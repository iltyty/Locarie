//
//  LocarieDivider.swift
//  locarie
//
//  Created by qiuty on 21/06/2024.
//

import SwiftUI

struct LocarieDivider: View {
  var body: some View {
    Rectangle()
      .fill(LocarieColor.greyMedium)
      .frame(height: 1.5)
      .frame(maxWidth: .infinity)
  }
}

#Preview {
  LocarieDivider()
}
