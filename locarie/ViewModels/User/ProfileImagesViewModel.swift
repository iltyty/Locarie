//
//  ProfileImagesViewModel.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import Combine
import Foundation

@MainActor final class ProfileImagesViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var profileImageUrls = [String]()
  @Published var photoViewModel = PhotoViewModel()

  private let networking: ProfileImagesUploadService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: ProfileImagesUploadService
    = ProfileImagesUploadServiceImpl.shared)
  {
    self.networking = networking
  }

  func upload(userId id: Int64) {
    guard photoViewModel.attachments.count > 1 else { return }
    let data = photoViewModel.attachments.map(\.data)
    let filenames = photoViewModel.selection.enumerated().map { i, item in
      let fileExtension = item.supportedContentTypes.first?
        .preferredFilenameExtension ?? ".jpg"
      return "\(i + 1).\(fileExtension)"
    }
    let mimeTypes = photoViewModel.selection.map { item in
      item.supportedContentTypes.first?
        .preferredMIMEType ?? defaultImageMimeType
    }
    state = .loading
    networking.upload(
      id: id,
      data: data,
      filenames: filenames,
      mimeTypes: mimeTypes
    )
    .sink { [weak self] response in
      guard let self else { return }
      handleResponse(response)
    }
    .store(in: &subscriptions)
  }

  private func handleResponse(_ response: ProfileImagesUploadResponse) {
    debugPrint("image get reponse: ", response)
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      if dto.status == 0 {
        state = .finished
      } else {
        state = .failed(newNetworkError(response: dto))
      }
    }
  }
}

extension ProfileImagesViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
