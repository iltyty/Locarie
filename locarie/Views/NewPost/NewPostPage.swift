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

  @FocusState private var isEditing

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @ObservedObject private var viewRouter = BottomTabViewRouter.shared

  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var postVM = PostCreateViewModel()

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    GeometryReader { _ in
      VStack(alignment: .leading, spacing: Constants.vSpacing) {
        navigationBar.ignoresSafeArea(.keyboard)
        content
        Spacer()
        postButton
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        Color.clear.contentShape(Rectangle())
          .onTapGesture {
            isEditing = false
          }
      )
    }
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
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      BusinessUserStatusRow(vm: profileVM).padding(.horizontal)
      photosPicker
      photoCount
      paragraphInput.padding(.top, -Constants.vSpacing)
      categories
    }
  }
}

private extension NewPostPage {
  var navigationBar: some View {
    NavigationBar("Post")
  }

  var photosPicker: some View {
    LazyVGrid(columns: gridColumns) {
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
    .padding(.horizontal)
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
        ImageDeleteButton().onTapGesture {
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
        .padding(.horizontal)
        .foregroundStyle(LocarieColor.greyDark)
        .background(Capsule().fill(LocarieColor.greyMedium))
    }
    .padding(.horizontal)
  }

  var gridColumns: [GridItem] {
    [
      GridItem(.fixed(Constants.photoSize), alignment: .bottomTrailing),
      GridItem(.fixed(Constants.photoSize), alignment: .bottomTrailing),
      GridItem(.fixed(Constants.photoSize), alignment: .bottomTrailing),
    ]
  }
}

private extension NewPostPage {
  var paragraphInput: some View {
    VStack {
      TextEditorPlus(text: $postVM.post.content, hint: "Paragraph...")
        .focused($isEditing)
        .padding([.horizontal])
        .frame(height: Constants.inputHeight, alignment: .top)
      Divider().padding(.horizontal)
    }
  }

  var categories: some View {
    VStack(alignment: .leading) {
      Text("Categories").foregroundStyle(LocarieColor.greyDark)
      WrappingHStack {
        ForEach(profileVM.dto.categories, id: \.self) { category in
          ProfileBusinessCategoryView(category)
        }
      }
    }
    .padding(.horizontal)
  }
}

extension NewPostPage {
  var postButton: some View {
    Button {
      postVM.create()
    } label: {
      BackgroundButtonFormItem(title: "Post")
        .padding(.horizontal)
        .opacity(buttonOpacity)
    }
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
  static let vSpacing: CGFloat = 16
  static let photoSize: CGFloat = 114
  static let photoIconSize: CGFloat = 28
  static let photoCornerRadius: CGFloat = 16
  static let inputHeight: CGFloat = 150
}

#Preview {
  NewPostPage()
}
