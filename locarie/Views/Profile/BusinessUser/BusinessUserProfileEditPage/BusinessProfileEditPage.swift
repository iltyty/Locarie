//
//  BusinessProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Alamofire
import CoreLocation
@_spi(Experimental) import MapboxMaps
import PhotosUI
import SwiftUI

struct BusinessProfileEditPage: View {
  @State var birthday = Date()
  @State var birthdayFormatted = ""
  @State var isSheetPresented = false
  @State var viewport: Viewport = .followPuck(zoom: GlobalConstants.mapZoom)

  @StateObject private var avatarVM = AvatarUploadViewModel()
  @StateObject private var profileGetVM = ProfileGetViewModel()
  @StateObject private var profileUpdateVM = ProfileUpdateViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

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
      profileGetVM.getProfile(userId: cacheVM.getUserId())
    }
    .onReceive(avatarVM.$state) { state in
      handleAvatarUpdateStateChange(state)
    }
    .onReceive(profileGetVM.$state) { state in
      handleProfileGetViewModelStateChange(state)
    }
    .onReceive(profileUpdateVM.$state) { state in handleProfileUpdateViewModelStateChange(state)
    }
    .onReceive(profileUpdateVM.$dto) { dto in
      if let location = dto.location {
        viewport = .camera(center: CLLocationCoordinate2D(
          latitude: location.latitude, longitude: location.longitude
        ), zoom: GlobalConstants.mapZoom, pitch: 0)
      }
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
      Text("Edit business images")
        .fontWeight(.semibold)
      ScrollView(.horizontal) {
        NavigationLink(value: Router.Destination.businessImagesEdit) {
          HStack {
            if profileGetVM.dto.profileImageUrls.isEmpty {
              defaultImages
            } else {
              profileImages
            }
          }
        }
        .buttonStyle(.plain)
      }
      .scrollIndicators(.hidden)
    }
  }

  var defaultImages: some View {
    ForEach(0 ..< Constants.defaultProfileImagesCount, id: \.self) { i in
      ZStack {
        RoundedRectangle(cornerRadius: Constants.profileImageCornerRadius)
          .fill(LocarieColor.greyMedium)
          .strokeBorder(
            i == 0 ? LocarieColor.primary : LocarieColor.greyMedium,
            style: .init(lineWidth: i == 0 ? Constants.firstProfileImageStrokeWidth : 0)
          )
          .frame(width: Constants.profileImageSize, height: Constants.profileImageSize)
        Image("DefaultImage")
          .resizable()
          .scaledToFit()
          .frame(width: Constants.defaultIconSize, height: Constants.defaultIconSize)
      }
    }
  }

  @ViewBuilder
  var profileImages: some View {
    let urls = profileGetVM.dto.profileImageUrls
    ForEach(urls.indices, id: \.self) { i in
      BusinessImageView(
        url: URL(string: urls[i]),
        size: Constants.profileImageSize,
        bordered: i == 0
      )
    }
  }

  var avatarEditor: some View {
    HStack {
      Spacer()
      AvatarEditor(photoViewModel: avatarVM.photoViewModel)
      Spacer()
    }
  }

  @ViewBuilder
  var businessNameInput: some View {
    let text = "Business name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      text: $profileUpdateVM.dto.businessName
    )
  }

  var usernameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "@Username",
      hint: "Username",
      text: $profileUpdateVM.dto.username
    )
  }

  var categoryInput: some View {
    NavigationLink {
      BusinessCategoryPage(categories: $profileUpdateVM.dto.categories)
    } label: {
      LinkFormItemWithInlineTitle(
        title: "Categories",
        hint: "Categories",
        textArray: $profileUpdateVM.dto.categories
      )
    }
    .buttonStyle(.plain)
  }

  var bioInput: some View {
    NavigationLink {
      BioEditPage(bio: $profileUpdateVM.dto.introduction)
    } label: {
      LinkFormItemWithInlineTitle(
        title: "Bio",
        hint: "Bio",
        text: $profileUpdateVM.dto.introduction
      )
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  var locationInput: some View {
    LocationSettingsItem(location: $profileUpdateVM.dto, viewport: $viewport)
  }

  var openingHoursInput: some View {
    NavigationLink {
      OpeningHoursEditPage(businessHoursDtos: $profileUpdateVM.dto
        .businessHours)
    } label: {
      LinkFormItemWithInlineTitle(
        title: "Opening hours",
        hint: "Edit opening hours",
        text: $profileUpdateVM.dto.formattedBusinessHours
      )
    }
    .buttonStyle(.plain)
  }

  var linkInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "Add link",
      hint: "Add link (optional)",
      text: $profileUpdateVM.dto.homepageUrl
    )
  }

  var phoneInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "Phone",
      hint: "Phone (optional)",
      text: $profileUpdateVM.dto.phone
    )
  }

  var personalDetailTitle: some View {
    Text("Personal info")
      .fontWeight(.semibold)
  }

  @ViewBuilder
  var firstNameInput: some View {
    let text = "First Name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      text: $profileUpdateVM.dto.firstName
    )
  }

  @ViewBuilder
  var lastNameInput: some View {
    let text = "Last Name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      text: $profileUpdateVM.dto.lastName
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
      profileUpdateVM.dto.birthday = birthday
      birthdayFormatted = profileUpdateVM.dto.formattedBirthday
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
    let userId = cacheVM.getUserId()
    avatarVM.upload(userId: userId)
    profileUpdateVM.updateProfile(userId: userId)
  }

  func handleProfileGetViewModelStateChange(
    _ state: ProfileGetViewModel.State
  ) {
    if case .finished = state {
      let dto = profileGetVM.dto
      if let birthday = dto.birthday {
        self.birthday = birthday
      }
      birthdayFormatted = dto.formattedBirthday
      profileUpdateVM.dto = dto
    }
  }

  func handleAvatarUpdateStateChange(
    _ state: AvatarUploadViewModel.State
  ) {
    if case let .finished(avatarUrl) = state {
      guard let avatarUrl else { return }
      cacheVM.setAvatarUrl(avatarUrl)
    }
  }

  func handleProfileImagesUpdateStateChange(
    _ state: BusinessImagesViewModel.State
  ) {
    if case .uploadFinished = state {
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
      cacheVM.setUserInfo(dto)
    }
    dismiss()
  }

  func handleProfileUpdateError(_ error: NetworkError) {
    print(error)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
  static let defaultIconSize: CGFloat = 28
  static let defaultProfileImagesCount = 5

  static let firstProfileImageStrokeWidth: CGFloat = 3
  static let profileImageSize: CGFloat = 114
  static let profileImageMaxCount = 5
  static let profileImageCornerRadius: CGFloat = 16
  static let profileImageAspectRatio: CGFloat = 4 / 3
  static let profileImagePickerCornerRadius: CGFloat = 10
  static let birthdaySheetHeightFraction: CGFloat = 0.4
}

#Preview {
  BusinessProfileEditPage()
}
