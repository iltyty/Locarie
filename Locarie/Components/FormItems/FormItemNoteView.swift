//
//  FormItemNoteView.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI

struct FormItemNoteView: View {
  var note: String

  init(_ note: String = "") { self.note = note }

  var body: some View {
    if !note.isEmpty {
      Text(note)
        .font(.custom(GlobalConstants.fontName, size: 14))
        .foregroundStyle(LocarieColor.greyDark)
        .padding(.top, 8)
        .padding(.leading, 16)
    } else {
      EmptyView()
    }
  }
}
