//
//  FormItemPasswordSwitchView.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI

struct FormItemPasswordSwitchView: View {
  @Binding var showing: Bool

  var body: some View {
    Image(showing ? "Eye" : "Eye.Grey")
      .resizable()
      .scaledToFit()
      .frame(size: 23)
      .contentShape(Rectangle())
      .onTapGesture { showing.toggle() }
  }
}
