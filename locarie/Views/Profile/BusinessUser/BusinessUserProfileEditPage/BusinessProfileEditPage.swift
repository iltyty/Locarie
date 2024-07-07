//
//  BusinessProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Alamofire
import CoreLocation
import Kingfisher
@_spi(Experimental) import MapboxMaps
import PhotosUI
import SwiftUI

struct BusinessProfileEditPage: View {
  @State private var birthday = Date()
  @State private var birthdayFormatted = ""
  @State private var viewport: Viewport = .followPuck(zoom: GlobalConstants.mapZoom)

  @State private var presentingAlert = false
  @State private var presentingSheet = false
  @State private var presentingNotPublicSheet = false

  @StateObject private var avatarVM = AvatarUploadViewModel()
  @StateObject private var profileGetVM = ProfileGetViewModel()
  @StateObject private var profileUpdateVM = ProfileUpdateViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(spacing: 0) {
        NavigationBar("Edit profile", right: saveButton, divider: true)
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            profileImagesEditor.padding(.top, 24)
            avatarEditor.padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 16) {
              businessNameInput
              usernameInput
              categoryInput
              bioInput
              locationInput
              openingHoursInput
              linkInput
              phoneInput
            }
            .padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 16) {
              personalDetailTitle
              firstNameInput
              lastNameInput
              birthdayInput
            }
            .padding(.horizontal, 16)
          }
        }
        .scrollIndicators(.hidden)
        .keyboardAdaptive()
      }
      if !cacheVM.cache.profileComplete {
        NotPublicButton()
          .padding(.bottom, 102)
          .padding(.trailing, 24)
          .onTapGesture {
            presentingNotPublicSheet = true
          }
      }
    }
    .alert("Profile saved", isPresented: $presentingAlert) {
      Button("OK") {}
    }
    .sheet(isPresented: $presentingSheet) { birthdaySheet }
    .sheet(isPresented: $presentingNotPublicSheet) {
      Group {
        if #available(iOS 16.4, *) {
          NotPublicSheetView(user: profileGetVM.dto).presentationCornerRadius(24)
        } else {
          NotPublicSheetView(user: profileGetVM.dto)
        }
      }
      .presentationDetents([.height(450)])
    }
    .onAppear {
      profileGetVM.getProfile(userId: cacheVM.getUserId())
    }
    .onReceive(avatarVM.$state) { state in
      handleAvatarUpdateStateChange(state)
    }
    .onReceive(profileGetVM.$state) { state in
      handleProfileGetViewModelStateChange(state)
    }
    .onReceive(profileUpdateVM.$state) { state in
      handleProfileUpdateViewModelStateChange(state)
    }
    .onReceive(profileUpdateVM.$dto) { dto in
      if let location = dto.location {
        viewport = .camera(center: CLLocationCoordinate2D(
          latitude: location.latitude, longitude: location.longitude
        ), zoom: GlobalConstants.mapZoom, pitch: 0)
      }
    }
  }
}

private extension BusinessProfileEditPage {
  var saveButton: some View {
    Button("Save") {
      updateProfile()
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  var profileImagesEditor: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Edit business images")
        .fontWeight(.bold)
        .padding(.horizontal, 32)
      ScrollView(.horizontal) {
        NavigationLink {
          BusinessImagesEditPage()
        } label: {
          HStack {
            profileImages
            defaultImages
          }
          .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
      }
      .scrollIndicators(.hidden)
    }
  }

  var profileImages: some View {
    ForEach(profileImageUrls.indices, id: \.self) { i in
      BusinessImageView(
        url: URL(string: profileImageUrls[i]),
        size: Constants.profileImageSize,
        bordered: i == 0
      )
    }
  }

  var profileImageUrls: [String] {
    profileGetVM.dto.profileImageUrls
  }

  var defaultImages: some View {
    ForEach(0 ..< 9 - profileImageUrls.count, id: \.self) { i in
      ZStack {
        if #available(iOS 17.0, *) {
          RoundedRectangle(cornerRadius: Constants.profileImageCornerRadius)
            .fill(LocarieColor.greyMedium)
            .strokeBorder(
              i == 0 && profileImageUrls.isEmpty ? LocarieColor.primary : LocarieColor.greyMedium,
              style: .init(lineWidth: i == 0 ? Constants.firstProfileImageStrokeWidth : 0)
            )
            .frame(size: Constants.profileImageSize)
        } else {
          RoundedRectangle(cornerRadius: Constants.profileImageCornerRadius)
            .strokeBorder(
              i == 0 && profileImageUrls.isEmpty ? LocarieColor.primary : LocarieColor.greyMedium,
              style: .init(lineWidth: i == 0 ? Constants.firstProfileImageStrokeWidth : 0)
            )
            .background(
              RoundedRectangle(cornerRadius: Constants.profileImageCornerRadius)
                .fill(LocarieColor.greyMedium)
            )
            .frame(size: Constants.profileImageSize)
        }
        Image("DefaultImage")
          .resizable()
          .scaledToFit()
          .frame(size: Constants.defaultIconSize)
      }
    }
  }

  var avatarEditor: some View {
    HStack {
      Spacer()
      AvatarEditor(photoVM: avatarVM.photoViewModel)
      Spacer()
    }
  }

  @ViewBuilder
  var businessNameInput: some View {
    let text = "Business name"
    TextEditFormItemWithInlineTitle(
      title: text,
      hint: text,
      note: "Maximum 25 letters.",
      text: $profileUpdateVM.dto.businessName
    )
  }

  var usernameInput: some View {
    TextEditFormItemWithInlineTitle(
      title: "@Username",
      hint: "Username",
      note: "Only letters, numbers, and full stops are allowed.",
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
      .id(cacheVM.cache.avatarId)
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
    Text("Personal info").fontWeight(.bold).padding(.horizontal, 16)
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
      presentingSheet = true
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
      presentingNotPublicSheet = !dto.isProfileComplete
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
      ImageCache.default.removeImage(forKey: avatarUrl)
      cacheVM.setAvatarUrl(avatarUrl)
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
      cacheVM.setProfileComplete(dto.isProfileComplete)
    }
    presentingAlert = true
  }

  func handleProfileUpdateError(_ error: NetworkError) {
    print(error)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
  static let defaultIconSize: CGFloat = 28

  static let imageCropSize: CGFloat = 250

  static let firstProfileImageStrokeWidth: CGFloat = 3
  static let profileImageSize: CGFloat = 114
  static let profileImageCornerRadius: CGFloat = 16
  static let birthdaySheetHeightFraction: CGFloat = 0.4
}

#Preview {
  BusinessProfileEditPage()
}
