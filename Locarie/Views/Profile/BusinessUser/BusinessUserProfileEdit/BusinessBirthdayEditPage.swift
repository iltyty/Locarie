//
//  BusinessBirthdayEditPage.swift
//  Locarie
//
//  Created by qiu on 2024/11/16.
//

import SwiftUI

struct BusinessBirthdayEditPage: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel
  @Binding var birthdayFormatted: String
  
  @State private var birthday = Date()
  @State private var presentingSheet = false
  @Environment(\.dismiss) private var dismiss

  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar("Birthday", right: saveButton, divider: true)
      Spacer()
      LinkFormItemWithInlineTitle(
        title: "Birthday", hint: "Birthday", text: $birthdayFormatted
      )
      .padding(.horizontal, 16)
      .onTapGesture {
        presentingSheet = true
      }
      Spacer()
      Spacer()
    }
    .sheet(isPresented: $presentingSheet) { birthdaySheet }
    .onAppear {
      if let day = profileUpdateVM.dto.birthday {
        birthday = day
      }
    }
    .onReceive(profileUpdateVM.$state) { state in
      switch state {
      case let .finished(dto):
        if let dto {
          cacheVM.setUserInfo(dto)
          cacheVM.setProfileComplete(dto.isProfileComplete)
          profileUpdateVM.state = .idle
        }
      default: return
      }
    }
  }
  
  private var saveButton: some View {
    Button("Save") { updateProfile() }
      .disabled(!profileUpdateVM.isFormValid)
      .fontWeight(.bold)
      .foregroundStyle(profileUpdateVM.isFormValid ? LocarieColor.primary : LocarieColor.greyDark)
  }
}

private extension BusinessBirthdayEditPage {
  var birthdaySheet: some View {
    VStack {
      birthdaySheetButtons
      birthdayPicker
    }
    .presentationDetents([.fraction(0.5)])
  }

  var birthdaySheetButtons: some View {
    HStack {
      birthdaySheetCancelButton
      Spacer()
      birthdaySheetDoneButton
    }
    .padding(.horizontal, 16)
  }

  var birthdaySheetCancelButton: some View {
    Button("Cancel") {
      presentingSheet = false
    }
    .foregroundStyle(.secondary)
  }

  var birthdaySheetDoneButton: some View {
    Button("Done") {
      profileUpdateVM.dto.birthday = birthday
      birthdayFormatted = profileUpdateVM.dto.formattedBirthday
      presentingSheet = false
    }
    .foregroundStyle(Color.locariePrimary)
  }

  var birthdayPicker: some View {
    DatePicker(
      "Birthday",
      selection: $birthday,
      in: ...Date(),
      displayedComponents: [.date]
    )
    .labelsHidden()
    .datePickerStyle(.wheel)
    .padding(.horizontal, 16)
  }
}


private extension BusinessBirthdayEditPage {
  func updateProfile() {
    let userId = cacheVM.getUserId()
    profileUpdateVM.updateProfile(userId: userId)
    dismiss()
  }
}
