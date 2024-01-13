//
//  BusinessUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Alamofire
import PhotosUI
import SwiftUI

struct BusinessUserProfileEditPage: View {
  @StateObject private var profileGetViewModel = ProfileGetViewModel()
  @StateObject private var profileUpdateViewModel = ProfileUpdateViewModel()
  @StateObject private var photoViewModel = PhotoViewModel()

  @State var birthday = Date()
  @State var birthdayFormatted = ""
  @State var isSheetPresented = false

  @Environment(\.dismiss) var dismiss

  private let id = Int64(LocalCacheViewModel.shared.cache.userId)

  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack(spacing: Constants.vSpacing) {
          navigationTitle
          avatarEditor
          profileImagesEditor(width: proxy.size.width * 0.8)
          businessNameInput
          usernameInput
          categoryInput
          bioInput
          openingHoursInput
          locationInput
          emailInput
          phoneInput
          firstNameInput
          lastNameInput
          birthdayInput
        }
      }
    }
    .sheet(isPresented: $isSheetPresented) { birthdaySheet }
    .onAppear {
      profileGetViewModel.getProfile(id: id)
    }
    .onReceive(profileGetViewModel.$state) { state in
      handleProfileGetViewModelStateChange(state)
    }
    .onReceive(profileUpdateViewModel.$state) { state in
      handleProfileUpdateViewModelStateChange(state)
    }
  }

  private func handleProfileGetViewModelStateChange(
    _ state: ProfileGetViewModel.State
  ) {
    if case let .finished(dto) = state {
      guard let dto else { return }
      if let birthday = dto.birthday {
        self.birthday = birthday
      }
      birthdayFormatted = dto.formattedBirthday
      profileUpdateViewModel.dto = dto
    }
  }

  private func handleProfileUpdateViewModelStateChange(
    _ state: ProfileUpdateViewModel.State
  ) {
    switch state {
    case let .finished(dto):
      handleProfileUpdateFinished(dto)
    case let .failed(error):
      handleProfileUpdateError(error)
    default: return
    }
  }

  private func handleProfileUpdateFinished(_: UserDto?) {
    dismiss()
  }

  private func handleProfileUpdateError(_ error: NetworkError) {
    print(error)
  }
}

private extension BusinessUserProfileEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit profile", right: saveButton)
  }

  var saveButton: some View {
    Button("Save") {
      profileUpdateViewModel.updateProfile(id: id)
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  func profileImagesEditor(width: CGFloat) -> some View {
    VStack(alignment: .leading) {
      Text("Edit profile images")
        .fontWeight(.bold)
        .padding(.leading)
      ScrollView(.horizontal) {
        HStack {
          profileImages(width: width)
          profileImagePicker(width: width)
        }
        .padding(.horizontal)
      }
    }
  }

  func profileImages(width: CGFloat) -> some View {
    ForEach(photoViewModel.attachments) { attachment in
      ImageAttachmentView(
        width: width,
        aspectRatio: Constants.profileImageAspectRatio,
        attachment: attachment
      )
    }
  }

  func profileImagePicker(width: CGFloat) -> some View {
    PhotosPicker(
      selection: $photoViewModel.selection,
      maxSelectionCount: 1,
      matching: .images,
      photoLibrary: .shared()
    ) { profileImagePickerContent(width: width) }
  }

  func profileImagePickerContent(width: CGFloat) -> some View {
    ZStack {
      profileImagePickerBackground(width: width)
      cameraIcon
    }
  }

  func profileImagePickerBackground(width: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: Constants.profileImagePickerCornerRadius)
      .fill(.ultraThickMaterial)
      .frame(width: width, height: width / Constants.profileImageAspectRatio)
  }

  var cameraIcon: some View {
    Image(systemName: "camera")
      .font(.system(size: Constants.cameraIconSize))
      .foregroundStyle(.gray)
  }

  var avatarEditor: some View {
    AvatarEditor()
  }

  @ViewBuilder
  var businessNameInput: some View {
    let text = "Business name"
    TextFormItem(
      title: text,
      hint: text,
      input: $profileUpdateViewModel.dto.businessName,
      showIcon: true
    )
  }

  var usernameInput: some View {
    TextFormItem(
      title: "@Username (for business)",
      hint: "Username",
      input: $profileUpdateViewModel.dto.username,
      showIcon: true
    )
  }

  var categoryInput: some View {
    NavigationLink {
      BusinessCategoryPage($profileUpdateViewModel.dto.category)
    } label: {
      LinkFormItem(
        title: "Business Category",
        hint: "Category",
        text: $profileUpdateViewModel.dto.category
      )
    }
    .buttonStyle(.plain)
  }

  var bioInput: some View {
    NavigationLink {
      BioEditPage(bio: $profileUpdateViewModel.dto.introduction)
    } label: {
      LinkFormItem(
        title: "Bio",
        hint: "Bio",
        text: $profileUpdateViewModel.dto.introduction
      )
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  var locationInput: some View {
    let text = "Location"
    NavigationLink {
      BusinessAddressPage(
        address: $profileUpdateViewModel.dto.address,
        location: $profileUpdateViewModel.dto.location
      )
    } label: {
      LinkFormItem(
        title: text,
        hint: text,
        text: $profileUpdateViewModel.dto.address
      )
    }
    .buttonStyle(.plain)
  }

  var openingHoursInput: some View {
    NavigationLink {
      OpeningHourEditPage(businessHoursDtos: $profileUpdateViewModel.dto
        .businessHours)
    } label: {
      LinkFormItem(
        title: "Opening hours",
        hint: "Edit opening hours",
        text: $profileUpdateViewModel.dto.formattedBusinessHours
      )
    }
    .buttonStyle(.plain)
  }

  var linkInput: some View {
    TextFormItem(
      title: "Link",
      hint: "Link optional",
      input: $profileUpdateViewModel.dto.homepageUrl
    )
  }

  @ViewBuilder
  var emailInput: some View {
    let text = "Email"
    TextFormItem(
      title: text, hint: text, input: $profileUpdateViewModel.dto.email,
      showIcon: true
    )
  }

  var phoneInput: some View {
    TextFormItem(
      title: "Phone",
      hint: "Phone optional",
      input: $profileUpdateViewModel.dto.phone,
      showIcon: true
    )
  }

  @ViewBuilder
  var firstNameInput: some View {
    let text = "First Name"
    TextFormItem(
      title: text,
      hint: text,
      input: $profileUpdateViewModel.dto.firstName,
      showIcon: true
    )
  }

  @ViewBuilder
  var lastNameInput: some View {
    let text = "Last Name"
    TextFormItem(
      title: text,
      hint: text,
      input: $profileUpdateViewModel.dto.lastName,
      showIcon: true
    )
  }

  @ViewBuilder
  var birthdayInput: some View {
    LinkFormItem(title: "Birthday", hint: "Birthday", text: $birthdayFormatted)
      .onTapGesture {
        isSheetPresented = true
      }
  }
}

private extension BusinessUserProfileEditPage {
  var birthdaySheet: some View {
    VStack {
      birthdaySheetButtons
      birthdayPicker
    }
    .presentationDetents([.fraction(Constants.birthdaySheetHeightFraction)])
  }

  var birthdaySheetButtons: some View {
    HStack {
      birthdaySheetCancelButton
      Spacer()
      birthdaySheetDoneButton
    }
    .padding(.horizontal)
  }

  var birthdaySheetCancelButton: some View {
    Button("Cancel") {
      isSheetPresented = false
    }
    .foregroundStyle(.secondary)
  }

  var birthdaySheetDoneButton: some View {
    Button("Done") {
      profileUpdateViewModel.dto.birthday = birthday
      birthdayFormatted = profileUpdateViewModel.dto.formattedBirthday
      isSheetPresented = false
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
    .padding(.horizontal)
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let cameraIconSize = 48.0
  static let profileImageAspectRatio = 16.0 / 9
  static let profileImagePickerCornerRadius = 10.0
  static let birthdaySheetHeightFraction = 0.4
}

#Preview {
  BusinessUserProfileEditPage()
}
