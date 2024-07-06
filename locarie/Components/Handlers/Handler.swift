//
//  Handler.swift
//  locarie
//
//  Created by qiuty on 06/07/2024.
//

import SwiftUI

struct Handler: View {
  var color: Color = LocarieColor.greyMedium

  var body: some View {
    Capsule()
      .fill(color)
      .frame(width: 48, height: 6)
  }
}

#Preview {
  Handler()
}
