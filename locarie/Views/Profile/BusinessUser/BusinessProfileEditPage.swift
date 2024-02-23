//
//  BusinessProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Alamofire
import PhotosUI
import SwiftUI

struct BusinessProfileEditPage: View {
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
    VStack(spacing: 0) {
      navigationBar
      ScrollView {
        content
      }
    }
    .sheet(isPresented: $isSheetPresented) { birthdaySheet }
    .onAppear {
      profileGetViewModel.getProfile(userId: cacheViewModel.getUserId())
    }
    .onReceive(avatarViewModel.$state) { state in
      handleAvatarUpdateStateChange(state)
    }
    .onReceive(profileImagesViewModel.$state) { state in
      handleProfileImagesUpdateStateChange(state)
    }
    .onReceive(profileGetViewModel.$state) { state in
      handleProfileGetViewModelStateChange(state)
    }
    .onReceive(profileUpdateViewModel.$state) { state in
      handleProfileUpdateViewModelStateChange(state)
    }
  }

  private var content: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      profileImagesEditor
      avatarEditor
      businessNameInput
      usernameInput
      categoryInput
      bioInput
      locationInput
      openingHoursInput
      linkInput
      phoneInput
      personalDetailTitle
      firstNameInput
      lastNameInput
      birthdayInput
    }
    .padding([.top, .horizontal])
  }
}

private extension BusinessProfileEditPage {
  var navigationBar: some View {
    NavigationBar("Edit profile", right: saveButton, divider: true)
  }

  var saveButton: some View {
    Button("Save") {
      updateProfile()
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  var profileImagesEditor: some View {
    VStack(alignment: .leading) {
      Text("Edit profile images")
        .fontWeight(.semibold)
      ScrollView(.horizontal) {
        HStack {
          profileImages
          profileImagePicker
        }
      }
      .scrollIndicators(.hidden)
    }
  }

  @ViewBuilder
  var profileImages: some View {
    let urls = profileGetViewModel.dto.profileImageUrls
    HStack {
      ForEach(urls.indices, id: \.self) { i in
        AsyncImageView(url: urls[i]) { image in
          image.resizable()
            .aspectRatio(Constants.profileImageAspectRatio, contentMode: .fill)
            .frame(width: Constants.profileImageWidth, alignment: .center)
            .clipShape(
              RoundedRectangle(cornerRadius: Constants.profileImageCornerRadius)
            )
            .clipped()
        }
        .frame(width: Constants.profileImageWidth)
      }
      ForEach(profileImagesViewModel.photoViewModel.attachments) { attachment in
        ImageAttachmentView(
          width: Constants.profileImageWidth,
          aspectRatio: Constants.profileImageAspectRatio,
          attachment: attachment
        )
      }
    }
  }

  var profileImagePicker: some View {
    PhotosPicker(
      selection: $profileImagesViewModel.photoViewModel.selection,
      maxSelectionCount: maxSelectionCount,
      matching: .images,
      photoLibrary: .shared()
    ) {
      profileImagePickerContent(width: Constants.profileImageWidth)
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
    HStack {
      Spacer()
      AvatarEditor(photoViewModel: avatarViewModel.photoViewModel)
      Spacer()
    }
  }

  @ViewBuilder
  var businessNameInput: some View {
    let text = "Business name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      text: $profileUpdateViewModel.dto.businessName
    )
  }

  var usernameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "@Username",
      hint: "Username",
      text: $profileUpdateViewModel.dto.username
    )
  }

  var categoryInput: some View {
    NavigationLink {
      BusinessCategoryPage(categories: $profileUpdateViewModel.dto.categories)
    } label: {
      LinkFormItemWithInlineTitle(
        title: "Categories",
        hint: "Categories",
        textArray: $profileUpdateViewModel.dto.categories
      )
    }
    .buttonStyle(.plain)
  }

  var bioInput: some View {
    NavigationLink {
      BioEditPage(bio: $profileUpdateViewModel.dto.introduction)
    } label: {
      LinkFormItemWithInlineTitle(
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
      BusinessAddressPage(dto: $profileUpdateViewModel.dto)
    } label: {
      LinkFormItemWithInlineTitle(
        title: text,
        hint: text,
        text: $profileUpdateViewModel.dto.address
      )
    }
    .buttonStyle(.plain)
  }

  var openingHoursInput: some View {
    NavigationLink {
      OpeningHoursEditPage(businessHoursDtos: $profileUpdateViewModel.dto
        .businessHours)
    } label: {
      LinkFormItemWithInlineTitle(
        title: "Opening hours",
        hint: "Edit opening hours",
        text: $profileUpdateViewModel.dto.formattedBusinessHours
      )
    }
    .buttonStyle(.plain)
  }

  var linkInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "Add link",
      hint: "Add link (optional)",
      text: $profileUpdateViewModel.dto.homepageUrl
    )
  }

  var phoneInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "Phone",
      hint: "Phone (optional)",
      text: $profileUpdateViewModel.dto.phone
    )
  }

  var personalDetailTitle: some View {
    Text("Personal details")
      .fontWeight(.semibold)
  }

  @ViewBuilder
  var firstNameInput: some View {
    let text = "First Name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      text: $profileUpdateViewModel.dto.firstName
    )
  }

  @ViewBuilder
  var lastNameInput: some View {
    let text = "Last Name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      text: $profileUpdateViewModel.dto.lastName
    )
  }

  @ViewBuilder
  var birthdayInput: some View {
    LinkFormItemWithInlineTitle(
      title: "Birthday", hint: "Birthday", text: $birthdayFormatted
    )
    .onTapGesture {
      isSheetPresented = true
    }
  }
}

private extension BusinessProfileEditPage {
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

private extension BusinessProfileEditPage {
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

  func handleProfileImagesUpdateStateChange(
    _ state: ProfileImagesViewModel.State
  ) {
    if case .finished = state {
      URLCache.imageCache.removeAllCachedResponses()
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

  func handleProfileUpdateFinished(_ dto: UserDto?) {
    if let dto {
      cacheViewModel.setUserInfo(dto)
    }
    dismiss()
  }

  func handleProfileUpdateError(_ error: NetworkError) {
    print(error)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
  static let cameraIconSize: CGFloat = 48
  static let profileImageWidth: CGFloat = 200
  static let profileImageHeight: CGFloat = 150
  static let profileImageMaxCount = 5
  static let profileImageCornerRadius: CGFloat = 5
  static let profileImageAspectRatio: CGFloat = 4 / 3
  static let profileImagePickerCornerRadius: CGFloat = 10
  static let birthdaySheetHeightFraction: CGFloat = 0.4
}

#Preview {
  BusinessProfileEditPage()
}
