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

  @StateObject private var postVM = PostCreateViewModel()

  var body: some View {
    VStack {
      photosPicker
      paragraphInput
      shareButton
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

extension NewPostPage {
  var photosPicker: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(postVM.photoVM.attachments) { attachment in
          ImageAttachmentView(
            width: Constants.imageWidth,
            height: Constants.imageHeight,
            attachment: attachment
          )
        }
        PhotosPicker(
          selection: $postVM.photoVM.selection,
          matching: .images,
          photoLibrary: .shared()
        ) {
          Image(systemName: "camera")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: Constants.imageWidth / 4)
            .foregroundStyle(.orange)
            .frame(width: Constants.imageWidth, height: Constants.imageHeight)
            .background(
              RoundedRectangle(cornerRadius: Constants.imageCornerRadius)
                .fill(.thickMaterial)
            )
        }
      }
    }
    .padding()
  }
}

private extension NewPostPage {
  var paragraphInput: some View {
    VStack {
      TextField("Paragraph", text: $postVM.post.content)
        .padding([.horizontal, .top])
        .frame(height: Constants.inputHeight, alignment: .top)
      Divider()
        .padding(.horizontal)
      Spacer()
    }
  }
}

extension NewPostPage {
  var shareButton: some View {
    Button {
      postVM.create()
    } label: {
      BackgroundButtonFormItem(title: "Post")
        .padding()
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
  static let imageWidth: CGFloat = 210
  static let imageHeight: CGFloat = 280
  static let imageCornerRadius: CGFloat = 18
  static let inputHeight: CGFloat = 100
}

#Preview {
  NewPostPage()
}
