//
//  BusinessUserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import PhotosUI
import SwiftUI

struct BusinessUserProfileEditPage: View {
  @StateObject private var cacheViewModel = LocalCacheViewModel()
  @StateObject private var profileViewModel = ProfileViewModel()
  @StateObject private var photoViewModel = PhotoViewModel()

  @State var birthday = ""
  @State var isSheetPresented = false

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
  }
}

private extension BusinessUserProfileEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit profile")
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
      input: $profileViewModel.dto.businessName,
      showIcon: true
    )
  }

  var usernameInput: some View {
    TextFormItem(
      title: "@Username (for business)",
      hint: "Username",
      input: $profileViewModel.dto.username,
      showIcon: true
    )
  }

  var categoryInput: some View {
    NavigationLink {
      BusinessCategoryPage($profileViewModel.dto.category)
    } label: {
      LinkFormItem(
        title: "Business Category",
        hint: "Category",
        text: $profileViewModel.dto.category
      )
    }
    .buttonStyle(.plain)
  }

  var bioInput: some View {
    NavigationLink {
      BioEditPage(bio: $profileViewModel.dto.introduction)
    } label: {
      LinkFormItem(
        title: "Bio",
        hint: "Bio",
        text: $profileViewModel.dto.introduction
      )
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  var locationInput: some View {
    let text = "Location"
    NavigationLink {
      BusinessAddressPage(
        address: $profileViewModel.dto.address,
        location: $profileViewModel.dto.location
      )
    } label: {
      LinkFormItem(title: text, hint: text, text: $profileViewModel.dto.address)
    }
    .buttonStyle(.plain)
  }

  var openingHoursInput: some View {
    NavigationLink {
      OpeningHourEditPage()
    } label: {
      // - FIXME: opening hour edit
      LinkFormItem(
        title: "Opening hours",
        hint: "Edit opening hours",
        text: $profileViewModel.dto.phone
      )
    }
    .buttonStyle(.plain)
  }

  var linkInput: some View {
    TextFormItem(
      title: "Link",
      hint: "Link optional",
      input: $profileViewModel.dto.homepageUrl
    )
  }

  @ViewBuilder
  var emailInput: some View {
    let text = "Email"
    TextFormItem(
      title: text, hint: text, input: $profileViewModel.dto.email,
      showIcon: true
    )
  }

  var phoneInput: some View {
    TextFormItem(
      title: "Phone",
      hint: "Phone optional",
      input: $profileViewModel.dto.phone,
      showIcon: true
    )
  }

  @ViewBuilder
  var firstNameInput: some View {
    let text = "First Name"
    TextFormItem(
      title: text,
      hint: text,
      input: $profileViewModel.dto.firstName,
      showIcon: true
    )
  }

  @ViewBuilder
  var lastNameInput: some View {
    let text = "Last Name"
    TextFormItem(
      title: text,
      hint: text,
      input: $profileViewModel.dto.lastName,
      showIcon: true
    )
  }

  @ViewBuilder
  var birthdayInput: some View {
    LinkFormItem(title: "Birthday", hint: "Birthday", text: $birthday)
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
      isSheetPresented = false
      birthday = profileViewModel.dto.formattedBirthday
    }
    .foregroundStyle(Color.locariePrimary)
  }

  var birthdayPicker: some View {
    DatePicker(
      "Birthday",
      selection: $profileViewModel.dto.birthday,
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
