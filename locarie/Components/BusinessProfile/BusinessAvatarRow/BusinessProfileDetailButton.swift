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
      presenting.toggle()
    } label: {
      Image(systemName: presenting ? "chevron.up" : "chevron.down")
        .frame(width: 18, height: 18)
    }
    .buttonStyle(.plain)
  }
}
