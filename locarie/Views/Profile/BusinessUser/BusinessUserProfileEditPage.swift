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

  // - FIXME: move birthday to UserDto
  @State var birthday = Date()

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
    RoundedRectangle(cornerRadius: 10)
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
      input: $profileViewModel.dto.businessName
    )
  }

  var usernameInput: some View {
    TextFormItem(
      title: "@Username (for business)",
      hint: "Username",
      input: $profileViewModel.dto.username
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
      BioPage()
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
      OpeningHourPage()
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
    TextFormItem(title: text, hint: text, input: $profileViewModel.dto.email)
  }

  var phoneInput: some View {
    TextFormItem(
      title: "Phone",
      hint: "Phone optional",
      input: $profileViewModel.dto.phone
    )
  }

  @ViewBuilder
  var firstNameInput: some View {
    let text = "First Name"
    TextFormItem(
      title: text,
      hint: text,
      input: $profileViewModel.dto.firstName
    )
  }

  @ViewBuilder
  var lastNameInput: some View {
    let text = "Last Name"
    TextFormItem(title: text, hint: text, input: $profileViewModel.dto.lastName)
  }

  @ViewBuilder
  var birthdayInput: some View {
    // - FIXME: birthday edit
    DatePicker("Birthday", selection: $birthday, displayedComponents: [.date])
      .datePickerStyle(.graphical)
      .padding(.horizontal)
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let cameraIconSize = 48.0
  static let profileImageAspectRatio = 16.0 / 9
}

#Preview {
  BusinessUserProfileEditPage()
}
