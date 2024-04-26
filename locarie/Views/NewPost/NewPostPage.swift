//
//  NewPostPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import PhotosUI
import SwiftUI

struct NewPostPage: View {
  @State private var isLoading = false
  @State private var isAlertShowing = false
  @State private var alertMessage = ""

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var postVM = PostCreateViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      navigationBar
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
          BusinessUserStatusRow(vm: profileVM).padding(.horizontal)
          photosPicker
          photoCount
          paragraphInput
          categories
        }
      }
      .scrollBounceBehavior(.basedOnSize)
      postButton
      BottomTabView()
    }
    .disabled(isLoading)
    .overlay { overlayView }
    .alert(
      alertMessage,
      isPresented: $isAlertShowing
    ) {
      Button("OK") {}
    }
    .onAppear {
      profileVM.getProfile(userId: cacheVM.getUserId())
    }
    .onChange(of: postVM.photoVM.selection) { _, _ in
      postVM.objectWillChange.send()
    }
    .onReceive(postVM.$state) { state in
      switch state {
      case .loading:
        isLoading = true
      case .finished:
        alertMessage = "Post success"
        isAlertShowing = true
        postVM.reset()
      case let .failed(error):
        // - TODO: alert message
        alertMessage = error.backendError?.message ??
          "Something went wrong, please try again later"
        isAlertShowing = true
      default: break
      }
    }
  }

  var overlayView: some View {
    isLoading ? loadingView : nil
  }

  var loadingView: some View {
    ProgressView().progressViewStyle(.circular)
  }
}

private extension NewPostPage {
  var navigationBar: some View {
    NavigationBar("Post", left: EmptyView())
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
