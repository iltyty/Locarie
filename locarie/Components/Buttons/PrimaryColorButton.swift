//
//  PrimaryColorButton.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct PrimaryColorButton: View {
  let text: String
  let action: () -> Void

  var body: some View {
    Button {
      action()
    } label: {
      primaryColorFormItemBuilder(text: text)
    }
  }
}
