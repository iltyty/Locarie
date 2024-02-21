//
//  NewPostPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import PhotosUI
import SwiftUI

struct NewPostPage: View {
  @StateObject var cacheViewModel = LocalCacheViewModel.shared
  @StateObject private var postViewModel = PostCreateViewModel()
  @StateObject private var photoViewModel = PhotoViewModel()

  @State private var isLoading = false
  @State private var isAlertShowing = false
  @State private var alertTitle: AlertTitle?

  var body: some View {
    contentView
      .disabled(isLoading)
      .overlay { overlayView }
      .alert(
        alertTitle?.rawValue ?? "",
        isPresented: $isAlertShowing
      ) { Button("OK") {} }
  }

  var contentView: some View {
    GeometryReader { proxy in
      VStack {
        photosPicker(imageSize: proxy.size.width * Constants
          .imageSizeProportion)
        editor(
          contentEditorHeight: proxy.size.height * Constants
            .contentEditorHeightProportion,
          title: $postViewModel.post.title,
          content: $postViewModel.post.content
        )
        shareButton
        BottomTabView()
      }
      .navigationTitle(Constants.pageTitle)
      .navigationBarTitleDisplayMode(.inline)
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
  func photosPicker(imageSize: CGFloat) -> some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
        ForEach(photoViewModel.attachments) { imageAttachment in
          ImageAttachmentView(
            size: imageSize, attachment: imageAttachment
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
            .frame(width: imageSize / 3)
            .foregroundStyle(.orange)
            .frame(width: imageSize, height: imageSize)
            .background(
              RoundedRectangle(cornerRadius: 5)
                .fill(.thickMaterial)
            )
        }
      }
      .padding()
    }
  }
}

extension NewPostPage {
  func editor(
    contentEditorHeight: CGFloat, title: Binding<String>,
    content: Binding<String>
  ) -> some View {
    VStack {
      TextField("Title", text: title)
        .padding(.horizontal)
      Divider()
        .padding(.horizontal)
      TextField("Paragraph", text: content)
        .padding([.horizontal, .top])
        .frame(height: contentEditorHeight, alignment: .top)
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
      Text(Constants.btnShareText)
        .font(.title2)
        .foregroundStyle(.white)
        .fontWeight(.bold)
        .background(
          Capsule()
            .fill(.orange)
            .frame(
              width: Constants.btnShareWidth,
              height: Constants.btnShareHeight
            )
        )
        .padding(.vertical)
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
    let user = UserId(id: cacheViewModel.getUserId())
    return PostCreateRequestDto(
      user: user,
      title: post.title,
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
  static let pageTitle = "Share"
  static let imageSizeProportion: CGFloat = 1 / 3.5
  static let contentEditorHeightProportion: CGFloat = 1 / 3
  static let btnShareText = "share"
  static let btnShareWidth: CGFloat = 180
  static let btnShareHeight: CGFloat = 50
}

#Preview {
  NewPostPage()
}
