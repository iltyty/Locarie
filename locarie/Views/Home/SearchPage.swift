//
//  SearchPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

struct SearchPage: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: 0) {
      SearchBarView(title: "Search")
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          dismiss()
        }
    }
    .navigationBarBackButtonHidden()
    .toolbar(.hidden)
  }
}

#Preview {
  SearchPage()
}
