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
  @State private var alertTitle: AlertTitle?

  @StateObject private var postViewModel = PostCreateViewModel()
  @StateObject private var photoViewModel = PhotoViewModel()

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
      alertTitle?.rawValue ?? "",
      isPresented: $isAlertShowing
    ) { Button("OK") {} }
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
        ForEach(photoViewModel.attachments) { imageAttachment in
          ImageAttachmentView(
            width: Constants.imageWidth,
            height: Constants.imageHeight,
            attachment: imageAttachment
          )
        }
        PhotosPicker(
          selection: $photoViewModel.selection,
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
      TextField("Paragraph", text: $postViewModel.post.content)
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
      create()
    } label: {
      BackgroundButtonFormItem(title: "Post")
        .padding()
        .opacity(buttonOpacity)
    }
    .disabled(isButtonDisabled)
  }

  var buttonOpacity: Double {
    postViewModel.isFormValid ? 1 : 0.5
  }

  var isButtonDisabled: Bool {
    !postViewModel.isFormValid
  }
}

extension NewPostPage {
  private func create() {
    isLoading = true
    Task {
      do {
        let dto = prepareDto()
        let images = prepareImages()
        let response = try await APIServices.createPost(
          dto: dto,
          images: images
        )
        handleCreateResponse(response)
      } catch {
        handleCreateError(error)
      }
    }
  }

  private func prepareDto() -> PostCreateRequestDto {
    let post = postViewModel.post
    let user = UserId(id: LocalCacheViewModel.shared.getUserId())
    return PostCreateRequestDto(
      user: user,
      content: post.content
    )
  }

  private func prepareImages() -> [Data] {
    photoViewModel.attachments.reduce(into: []) { partialResult, attachment in
      if let status = attachment.status, status.isFinished {
        partialResult.append(attachment.data)
      }
    }
  }

  private func handleCreateResponse(_ response: Response) {
    debugPrint(response)
    isLoading = false
    response.status == 0
      ? handleCreateSuccess(response)
      : handleCreateFailure(response)
  }

  private func handleCreateError(_ error: Error) {
    debugPrint(error)
    isLoading = false
    alertTitle = .unknownError
    isAlertShowing = true
  }

  private func handleCreateSuccess(_: Response) {
    alertTitle = .success
    isAlertShowing = true
    resetPage()
  }

  private func handleCreateFailure(_: Response) {
    alertTitle = .unknownError
    isAlertShowing = true
  }

  private func resetPage() {
    postViewModel.reset()
    photoViewModel.reset()
  }
}

private extension NewPostPage {
  enum AlertTitle: String {
    case success = "Share success"
    case unknownError = "Something went wrong, please try again later"
  }
}

private typealias Response = ResponseDto<PostCreateResponseDto>

private enum Constants {
  static let imageWidth: CGFloat = 210
  static let imageHeight: CGFloat = 280
  static let imageCornerRadius: CGFloat = 18
  static let inputHeight: CGFloat = 100
}

#Preview {
  NewPostPage()
}
