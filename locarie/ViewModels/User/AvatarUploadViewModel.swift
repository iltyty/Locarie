//
//  AvatarUploadViewModel.swift
//  locarie
//
//  Created by qiuty on 13/01/2024.
//

import Combine
import Foundation

@MainActor final class AvatarUploadViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var photoViewModel = PhotoViewModel()

  private let defaultAvatarFilename = "avatar.jpg"
  private let networking: AvatarUploadService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: AvatarUploadService = AvatarUploadServiceImpl.shared) {
    self.networking = networking
  }

  func upload(userId id: Int64) {
    guard photoViewModel.attachments.count == 1 else { return }
    let mimeType = getMimeType()
    let filename = getFilename()
    let data = photoViewModel.attachments[0].data
    return networking.upload(
      userId: id,
      data: data,
      filename: filename,
      mimeType: mimeType
    )
    .sink { [weak self] response in
      guard let self else { return }
      handleUploadResponse(response)
    }
    .store(in: &subscriptions)
  }

  private func getMimeType() -> String {
    guard photoViewModel.selection.count == 1 else {
      return defaultImageMimeType
    }
    if let mimeType = photoViewModel.selection[0].supportedContentTypes.first?
      .preferredMIMEType
    {
      return mimeType
    }
    return defaultImageMimeType
  }

  private func getFilename() -> String {
    guard photoViewModel.selection.count == 1 else {
      return defaultAvatarFilename
    }
    if let fileExtension = photoViewModel.selection[0].supportedContentTypes
      .first?
      .preferredFilenameExtension
    {
      return "avatar.\(fileExtension)"
    }
    return defaultAvatarFilename
  }

  private func handleUploadResponse(_ response: AvatarUploadResponse) {
    debugPrint(response)
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      state = dto.status == 0 ? .finished(dto.data)
        : .failed(newNetworkError(response: dto))
    }
  }
}

extension AvatarUploadViewModel {
  enum State {
    case idle
    case loading
    case finished(String?)
    case failed(NetworkError)
  }
}
