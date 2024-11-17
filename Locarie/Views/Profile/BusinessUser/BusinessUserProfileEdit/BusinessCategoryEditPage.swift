//
//  BusinessCategoryEditPage.swift
//  locarie
//
//  Created by qiuty on 16/12/2024.
//

import SwiftUI

struct BusinessCategoryEditPage: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel

  @State private var isSelected: [Bool] = .init(
    repeating: false,
    count: BusinessCategory.allCases.count
  )
  @Environment(\.dismiss) private var dismiss

  private let cacheVM = LocalCacheViewModel.shared
  private var allCategories: [String] {
    BusinessCategory.allCases.map(\.rawValue)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      NavigationBar("Business category", right: saveButton, padding: true)
      VStack(alignment: .leading, spacing: 0) {
        text.padding(.bottom, Constants.textBottomPadding)
        tags
        Spacer()
        selectedCount.padding(.bottom, 24)
      }
      .padding(.horizontal, 16)
    }
    .onAppear {
      for i in 0 ..< allCategories.count {
        if profileUpdateVM.dto.categories.contains(allCategories[i]) {
          isSelected[i] = true
        }
      }
    }
  }
  
  private var saveButton: some View {
    return Button("Save") { updateProfile() }
      .disabled(selected.isEmpty)
      .fontWeight(.bold)
      .foregroundStyle(selected.isEmpty ? LocarieColor.greyDark : LocarieColor.primary)
  }

  private var text: some View {
    HStack(spacing: 0) {
      Text("Select up to ")
      Text("3 tags ").foregroundStyle(LocarieColor.primary)
      Text("that match your business.")
    }
    .fontWeight(.bold)
  }

  private var tags: some View {
    WrappingHStack {
      ForEach(allCategories.indices, id: \.self) { i in
        let tag = allCategories[i]
        TagView(tag: tag, isSelected: isSelected[i])
          .onTapGesture {
            if isSelected[i] || selected.count < Constants.maxTagCount {
              isSelected[i].toggle()
            }
            print(selected.count)
          }
      }
    }
  }

  var selected: [Bool] {
    isSelected.filter { $0 }
  }

  var selectedCount: some View {
    HStack {
      Spacer()
      Text("\(selected.count) selected")
        .foregroundStyle(LocarieColor.greyDark)
        .padding(.vertical, 5)
        .padding(.horizontal, 16)
        .background { Capsule().fill(LocarieColor.greyMedium) }
    }
  }

  var tagCountValid: Bool {
    !selected.isEmpty && selected.count <= Constants.maxTagCount
  }

  var buttonOpacity: CGFloat {
    !tagCountValid ? Constants.buttonDisabledOpacity : 1
  }
}

private extension BusinessCategoryEditPage {
  func updateProfile() {
    profileUpdateVM.dto.categories = allCategories.enumerated().filter { i, _ in
        isSelected[i]
      }.map(\.element)
    let userId = cacheVM.getUserId()
    profileUpdateVM.updateProfile(userId: userId)
    dismiss()
  }
}

private enum Constants {
  static let maxTagCount = 3
  static let titleBottomPadding: CGFloat = 80
  static let textBottomPadding: CGFloat = 50
  static let tagVSpacing: CGFloat = 30
  static let buttonDisabledOpacity: CGFloat = 0.5
}
