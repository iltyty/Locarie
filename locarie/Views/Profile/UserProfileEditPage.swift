//
//  UserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Alamofire
import PhotosUI
import SwiftUI

struct UserProfileEditPage: View {
  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared

  @StateObject private var avatarViewModel = AvatarUploadViewModel()
  @StateObject private var profileGetViewModel = ProfileGetViewModel()
  @StateObject private var profileUpdateViewModel = ProfileUpdateViewModel()
  @StateObject private var profileImagesViewModel = ProfileImagesViewModel()

  @State var birthday = Date()
  @State var birthdayFormatted = ""
  @State var isSheetPresented = false

  @Environment(\.dismiss) var dismiss

  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack(spacing: Constants.vSpacing) {
          navigationTitle
          if isBusinessUser {
            profileImagesEditor(width: proxy.size.width * 0.8)
          }
          avatarEditor
          if isBusinessUser {
            businessNameInput
          }
          usernameInput
          if isBusinessUser {
            categoryInput
            bioInput
            locationInput
            openingHoursInput
            linkInput
          }
          emailInput
          if isBusinessUser {
            phoneInput
          }
          firstNameInput
          lastNameInput
          birthdayInput
        }
      }
    }
    .sheet(isPresented: $isSheetPresented) { birthdaySheet }
    .onAppear {
      profileGetViewModel.getProfile(userId: cacheViewModel.getUserId())
    }
    .onReceive(profileGetViewModel.$state) { state in
      handleProfileGetViewModelStateChange(state)
    }
    .onReceive(avatarViewModel.$state) { state in
      handleAvatarUpdateStateChange(state)
    }
    .onReceive(profileUpdateViewModel.$state) { state in
      handleProfileUpdateViewModelStateChange(state)
    }
  }

  private var isBusinessUser: Bool {
    profileGetViewModel.dto.type == .business
  }
}

private extension UserProfileEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit profile", right: saveButton)
  }

  var saveButton: some View {
    Button("Save") {
      updateProfile()
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
    let urls = profileGetViewModel.dto.profileImageUrls
    return Group {
      ForEach(urls.indices, id: \.self) { i in
        AsyncImageView(url: urls[i]) { image in
          image.resizable()
            .aspectRatio(Constants.profileImageAspectRatio, contentMode: .fill)
            .frame(width: width, alignment: .center)
            .clipShape(
              RoundedRectangle(cornerRadius: Constants.profileImageCornerRadius)
            )
            .clipped()
        }
        .frame(width: width)
      }
      ForEach(profileImagesViewModel.photoViewModel.attachments) { attachment in
        ImageAttachmentView(
          width: width,
          aspectRatio: Constants.profileImageAspectRatio,
          attachment: attachment
        )
      }
    }
  }

  func profileImagePicker(width: CGFloat) -> some View {
    PhotosPicker(
      selection: $profileImagesViewModel.photoViewModel.selection,
      maxSelectionCount: maxSelectionCount,
      matching: .images,
      photoLibrary: .shared()
    ) {
      profileImagePickerContent(width: width)
    }
    .disabled(maxSelectionCount == 0)
  }

  var maxSelectionCount: Int {
    max(0, Constants.profileImageMaxCount -
      profileGetViewModel.dto.profileImageUrls.count)
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
    AvatarEditor(photoViewModel: avatarViewModel.photoViewModel)
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
      title: "@Username",
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
      input: $profileUpdateViewModel.dto.homepageUrl,
      showIcon: true
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

private extension UserProfileEditPage {
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

private extension UserProfileEditPage {
  func updateProfile() {
    let userId = cacheViewModel.getUserId()
    profileImagesViewModel.upload(userId: userId)
    avatarViewModel.upload(userId: userId)
    profileUpdateViewModel.updateProfile(userId: userId)
  }

  func handleProfileGetViewModelStateChange(
    _ state: ProfileGetViewModel.State
  ) {
    if case .finished = state {
      let dto = profileGetViewModel.dto
      if let birthday = dto.birthday {
        self.birthday = birthday
      }
      birthdayFormatted = dto.formattedBirthday
      profileUpdateViewModel.dto = dto
    }
  }

  func handleAvatarUpdateStateChange(
    _ state: AvatarUploadViewModel.State
  ) {
    if case let .finished(avatarUrl) = state {
      guard let avatarUrl else { return }
      cacheViewModel.setAvatarUrl(avatarUrl)
    }
  }

  func handleProfileUpdateViewModelStateChange(
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

  func handleProfileUpdateFinished(_: UserDto?) {
    dismiss()
  }

  func handleProfileUpdateError(_ error: NetworkError) {
    print(error)
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let cameraIconSize = 48.0
  static let profileImageMaxCount = 5
  static let profileImageCornerRadius = 5.0
  static let profileImageAspectRatio = 16.0 / 9
  static let profileImagePickerCornerRadius = 10.0
  static let birthdaySheetHeightFraction = 0.4
}

#Preview {
  UserProfileEditPage()
}
