//
//  BusinessCategoryPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import SwiftUI

struct BusinessCategoryPage: View {
  @Environment(\.dismiss) var dismiss

  @Binding var categories: [String]

  @State var isSelected: [Bool] = .init(
    repeating: false,
    count: BusinessCategory.allCases.count
  )

  private var allCategories: [String] {
    BusinessCategory.allCases.map(\.rawValue)
  }

  var body: some View {
    VStack(alignment: .leading) {
      navigationTitle
      text
      tags
      Spacer()
      confirmButton
    }
    .onAppear {
      for i in 0 ..< allCategories.count {
        if categories.contains(allCategories[i]) {
          isSelected[i] = true
        }
      }
    }
  }

  private var navigationTitle: some View {
    NavigationTitle("Business category")
      .padding(.bottom, Constants.titleBottomPadding)
  }

  private var text: some View {
    Text("Please select the categories that match your business.")
      .padding(.horizontal)
      .padding(.bottom, Constants.textBottomPadding)
  }

  var tags: some View {
    VStack(alignment: .leading, spacing: Constants.tagVSpacing) {
      ForEach(allCategories.indices, id: \.self) { i in
        let tag = allCategories[i]
        TagView(tag: tag, isSelected: isSelected[i], large: true)
          .onTapGesture {
            isSelected[i].toggle()
          }
      }
    }
    .padding(.horizontal)
  }

  var confirmButton: some View {
    Button {
      categories = allCategories.enumerated().filter { i, _ in
        isSelected[i]
      }.map(\.element)
      dismiss()
    } label: {
      StrokeButtonFormItem(title: "Select")
    }
    .padding(.horizontal)
    .padding(.bottom)
    .disabled(isButtonDisabled)
    .opacity(buttonOpacity)
  }

  var isButtonDisabled: Bool {
    isSelected.filter { $0 }.isEmpty
  }

  var buttonOpacity: CGFloat {
    isButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private enum Constants {
  static let titleBottomPadding: CGFloat = 80
  static let textBottomPadding: CGFloat = 50
  static let tagVSpacing: CGFloat = 30
  static let buttonDisabledOpacity: CGFloat = 0.5
}

#Preview {
  BusinessCategoryPage(categories: .constant([]))
}
