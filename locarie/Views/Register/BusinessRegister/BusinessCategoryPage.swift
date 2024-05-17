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
      navigationBar
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

  private var navigationBar: some View {
    NavigationBar("Business category", padding: true)
  }

  private var text: some View {
    Text("Please select all tags that match your business.")
      .font(.callout)
      .fontWeight(.semibold)
      .padding(.horizontal)
      .padding(.bottom, Constants.textBottomPadding)
  }

  var tags: some View {
    WrappingHStack {
      ForEach(allCategories.indices, id: \.self) { i in
        let tag = allCategories[i]
        TagView(tag: tag, isSelected: isSelected[i], large: true)
          .onTapGesture {
            if isSelected[i] || selected.count < Constants.maxTagCount {
              isSelected[i].toggle()
            }
          }
      }
    }
    .padding(.horizontal)
  }

  var selected: [Bool] {
    isSelected.filter { $0 }
  }

  var confirmButton: some View {
    Button {
      categories = allCategories.enumerated().filter { i, _ in
        isSelected[i]
      }.map(\.element)
      dismiss()
    } label: {
      StrokeButtonFormItem(title: "Next Step")
    }
    .padding(.horizontal)
    .padding(.bottom)
    .disabled(!tagCountValid)
    .opacity(buttonOpacity)
  }

  var tagCountValid: Bool {
    !selected.isEmpty && selected.count <= Constants.maxTagCount
  }

  var buttonOpacity: CGFloat {
    !tagCountValid ? Constants.buttonDisabledOpacity : 1
  }
}

private enum Constants {
  static let maxTagCount = 3
  static let titleBottomPadding: CGFloat = 80
  static let textBottomPadding: CGFloat = 50
  static let tagVSpacing: CGFloat = 30
  static let buttonDisabledOpacity: CGFloat = 0.5
}

#Preview {
  BusinessCategoryPage(categories: .constant([]))
}
