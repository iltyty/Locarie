//
//  PostCreateViewModel.swift
//  locarie
//
//  Created by qiuty on 18/12/2023.
//

import Combine
import Foundation

@MainActor final class PostCreateViewModel: BaseViewModel {
  private let networking: PostCreateService
  @Published var post: PostCreateRequestDto

  @Published var isFormValid = false
  @Published var state: State = .idle
  @Published var photoVM = PhotoViewModel()

  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostCreateService = PostCreateServiceImpl.shared) {
    let user = UserId(id: Int64(LocalCacheViewModel.shared.getUserId()))
    post = PostCreateRequestDto(user: user, content: "")
    self.networking = networking
    super.init()
    storeIsFormValidPublisher()
  }

  private func storeIsFormValidPublisher() {
    isImagesValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &subscriptions)
  }

  func reset() {
    post.content = ""
    photoVM = PhotoViewModel()
  }

  func create() {
    guard !photoVM.attachments.isEmpty else { return }
    state = .loading
    let data = getImagesData()
    let filenames = getImageFilenames()
    let mimeTypes = getImageMimeTypes()
    dataPreprocessing()
    networking.create(post, images: data, filenames: filenames, mimeTypes: mimeTypes)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func dataPreprocessing() {
    post.content = post.content.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func getImagesData() -> [Data] {
    photoVM.attachments.map(\.data)
  }

  private func getImageFilenames() -> [String] {
    photoVM.selection.enumerated().map { i, item in
      let fileExtension = item.supportedContentTypes.first?
        .preferredFilenameExtension ?? ".jpg"
      return "\(i + 1).\(fileExtension)"
    }
  }

  private func getImageMimeTypes() -> [String] {
    photoVM.selection.map { item in
      item.supportedContentTypes.first?
        .preferredMIMEType ?? defaultImageMimeType
    }
  }

  private func handleResponse(_ response: PostCreateResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    if response.value!.status == 0 {
      state = .finished
      return
    }
    state = .failed(newNetworkError(response: response.value!))
  }
}

private extension PostCreateViewModel {
  var isImagesValidPublisher: AnyPublisher<Bool, Never> {
    $photoVM
      .map { !$0.attachments.isEmpty }
      .eraseToAnyPublisher()
  }
}

extension PostCreateViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
