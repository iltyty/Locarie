//
//  BusinessCategoryPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessCategoryPage: View {
  @Environment(\.dismiss) var dismiss

  @Binding var category: String

  init(_ category: Binding<String>) {
    _category = category
  }

  var body: some View {
    VStack {
      navigationTitle
      tags
      confirmButton
      Spacer()
    }
  }

  var navigationTitle: some View {
    NavigationTitle("Business category")
      .padding(.bottom, Constants.titlePadding)
  }

  var tags: some View {
    WrappingHStack(alignment: .leading) {
      ForEach(BusinessCategory.allCases, id: \.self) { businessCategory in
        let tag = businessCategory.rawValue
        TagView(tag: tag, isSelected: tag == category)
          .onTapGesture {
            category = tag
          }
      }
    }
    .padding(.bottom)
  }

  var confirmButton: some View {
    Button {
      dismiss()
    } label: {
      primaryColorFormItemBuilder(text: "Confirm")
    }
    .disabled(isButtonDisabled)
    .opacity(buttonOpacity)
  }

  var isButtonDisabled: Bool {
    category.isEmpty
  }

  var buttonOpacity: CGFloat {
    isButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private enum Constants {
  static let titlePadding = 100.0
  static let buttonDisabledOpacity = 0.5
}

#Preview {
  @State var category = ""
  return BusinessCategoryPage($category)
}
