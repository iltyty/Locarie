//
//  NewPostPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import PhotosUI
import SwiftUI

struct NewPostPage: View {
  @State private var loading = false
  @State private var isAlertShowing = false
  @State private var alertMessage = ""

  @FocusState private var isEditing: Bool

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @ObservedObject private var viewRouter = BottomTabViewRouter.shared

  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var postVM = PostCreateViewModel()

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    GeometryReader { _ in
      VStack(alignment: .leading, spacing: 0) {
        NavigationBar("Post").ignoresSafeArea(.keyboard)
        content
        Spacer()
        postButton
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .keyboardDismissable(focus: $isEditing)
    .ignoresSafeArea(.keyboard)
    .loadingIndicator(loading: $loading)
    .alert(
      alertMessage,
      isPresented: $isAlertShowing
    ) {
      Button("OK") {}
    }
    .onAppear {
      profileVM.getProfile(userId: cacheVM.getUserId())
    }
    .onReceive(postVM.$state) { state in
      switch state {
      case .loading:
        loading = true
      case .finished:
        loading = false
        viewRouter.currentPage = .profile
        dismiss()
        postVM.reset()
      case let .failed(error):
        loading = false
        // - TODO: alert message
        alertMessage = error.backendError?.message ??
          "Something went wrong, please try again later"
        isAlertShowing = true
      default: break
      }
    }
    .onChange(of: postVM.photoVM.selection) { _ in
      postVM.objectWillChange.send()
    }
  }

  private var content: some View {
    VStack(alignment: .leading, spacing: 0) {
      BusinessUserStatusRow(vm: profileVM).padding(.vertical, 16)
      photosPicker.padding(.bottom, 24)
      photoCount.padding(.bottom, 5)
      paragraphInput
      categories
    }
    .padding(.horizontal, 16)
  }
}

private extension NewPostPage {
  var photosPicker: some View {
    LazyVGrid(columns: gridColumns, spacing: 8) {
      photos
      if postVM.photoVM.attachments.count < Constants.maxImageCount {
        PhotosPicker(
          selection: $postVM.photoVM.selection,
          maxSelectionCount: Constants.maxImageCount,
          matching: .images,
          photoLibrary: .shared()
        ) {
          Image(systemName: "plus")
            .resizable()
            .foregroundStyle(LocarieColor.greyDark)
            .frame(width: Constants.photoIconSize, height: Constants.photoIconSize)
            .frame(width: Constants.photoSize, height: Constants.photoSize)
            .background(
              RoundedRectangle(cornerRadius: Constants.photoCornerRadius)
                .fill(.thickMaterial)
            )
        }
      }
    }
  }

  @ViewBuilder
  var photos: some View {
    let attachments = postVM.photoVM.attachments
    ForEach(attachments.indices, id: \.self) { i in
      ZStack(alignment: .topTrailing) {
        NavigationLink {
          SelectedPhotoPage(vm: postVM.photoVM)
        } label: {
          ImageAttachmentView(
            width: Constants.photoSize,
            height: Constants.photoSize,
            attachment: attachments[i]
          )
        }
        .buttonStyle(.plain)
        ImageDeleteButton()
          .contentShape(Rectangle())
          .onTapGesture {
            postVM.photoVM.selection.remove(at: i)
            postVM.objectWillChange.send()
          }
      }
    }
  }

  var photoCount: some View {
    HStack {
      Spacer()
      Text("\(postVM.photoVM.attachments.count)/\(Constants.maxImageCount)")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
        .foregroundStyle(LocarieColor.greyDark)
        .background(Capsule().fill(LocarieColor.greyMedium))
    }
  }

  var gridColumns: [GridItem] {
    [
      GridItem(.flexible(minimum: Constants.photoSize, maximum: 3 * Constants.photoSize), alignment: .leading),
      GridItem(.flexible(minimum: Constants.photoSize, maximum: 3 * Constants.photoSize), alignment: .center),
      GridItem(.flexible(minimum: Constants.photoSize, maximum: 3 * Constants.photoSize), alignment: .trailing),
    ]
  }
}

private extension NewPostPage {
  var paragraphInput: some View {
    VStack(spacing: 24) {
      TextEditorPlus(text: $postVM.post.content, hint: "Paragraph...")
        .focused($isEditing)
        .frame(height: Constants.inputHeight, alignment: .top)
      Divider().foregroundStyle(LocarieColor.greyMedium)
    }
  }

  var categories: some View {
    VStack(alignment: .leading) {
      Text("Categories")
        .padding(.vertical, 16)
        .foregroundStyle(LocarieColor.greyDark)
      HStack(spacing: 5) {
        ForEach(profileVM.dto.categories, id: \.self) { category in
          ProfileBusinessCategoryView(category)
        }
      }
    }
  }
}

extension NewPostPage {
  var postButton: some View {
    Button {
      postVM.create()
    } label: {
      BackgroundButtonFormItem(title: "Post").opacity(buttonOpacity)
    }
    .padding(.horizontal, 16)
    .disabled(isButtonDisabled)
  }

  var buttonOpacity: Double {
    postVM.isFormValid ? 1 : 0.5
  }

  var isButtonDisabled: Bool {
    !postVM.isFormValid
  }
}

private enum Constants {
  static let maxImageCount = 5
  static let photoSize: CGFloat = 114
  static let photoIconSize: CGFloat = 28
  static let photoCornerRadius: CGFloat = 16
  static let inputHeight: CGFloat = 150
}

#Preview {
  NewPostPage()
}
