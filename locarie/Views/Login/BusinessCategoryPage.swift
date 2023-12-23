//
//  BusinessCategoryPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessCategoryPage: View {
  @StateObject var registerViewModel = BusinessUserRegisterViewModel()

  var body: some View {
    VStack {
      navigationTitle
      searchBar
      tags
      Spacer()
      confirmButton
      Spacer()
    }
  }

  var navigationTitle: some View {
    navigationTitleBuilder(title: "Business category")
  }

  var searchBar: some View {
    SearchBarView()
  }

  var tags: some View {
    WrappingHStack {
      ForEach(Tag.allCases, id: \.self) { tag in
        TagView(tag)
      }
    }
  }

  var confirmButton: some View {
    primaryButtonBuilder(text: "Confirm") {
      print("confirm button tapped")
    }
  }
}

#Preview {
  BusinessCategoryPage()
}
