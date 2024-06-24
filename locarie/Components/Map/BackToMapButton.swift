//
//  BackToMapButton.swift
//  locarie
//
//  Created by qiuty on 24/06/2024.
//

import SwiftUI

struct BackToMapButton: View {
  var body: some View {
    Image(systemName: "map")
      .resizable()
      .foregroundStyle(.white)
      .frame(width: 18, height: 18)
      .frame(width: 82, height: 40)
      .background { Capsule().fill(.black) }
  }
}

#Preview {
  BackToMapButton()
}
