//
//  BusinessImagesViewModel.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import Combine
import Foundation
import Kingfisher

@MainActor final class BusinessImagesViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var imageUrls = [String]()
  @Published var existedImageUrls = [String]()
  @Published var existedImageData = [Data]()
  @Published var photoVM = PhotoViewModel()

  public let loader = ExistingImageLoader()

  private let networking: BusinessImagesService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: BusinessImagesService = BusinessImagesServiceImpl.shared) {
    self.networking = networking
  }

  public actor ExistingImageLoader {
    public func loadExistedImageData(on mainActor: BusinessImagesViewModel) async {
      for urlString in await mainActor.existedImageUrls {
        Task {
          if !ImageCache.default.isCached(forKey: urlString) {
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
              DispatchQueue.main.async {
                mainActor.existedImageData.append(data)
              }
            }
          } else {
            ImageCache.default.retrieveImage(forKey: urlString) { result in
              var loaded = false
              switch result {
              case let .success(value):
                if let image = value.image {
                  if let data = image.pngData() {
                    loaded = true
                    DispatchQueue.main.async {
                      mainActor.existedImageData.append(data)
                    }
                  } else if let data = image.jpegData(compressionQuality: 1) {
                    loaded = true
                    DispatchQueue.main.async {
                      mainActor.existedImageData.append(data)
                    }
                  }
                }
              default: break
              }
              if !loaded {
                if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                  DispatchQueue.main.async {
                    mainActor.existedImageData.append(data)
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  func get(userId id: Int64) {
    if case .loading = state {
      return
    }
    state = .loading
    networking.get(id: id).sink { [weak self] response in
      guard let self else { return }
      handleGetResponse(response)
    }
    .store(in: &subscriptions)
  }

  func handleGetResponse(_ response: BusinessImagesGetResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status == 0 {
      if let urls = dto.data {
        imageUrls = urls
        existedImageUrls = urls
      }
      state = .getFinished
    } else {
      state = .failed(newNetworkError(response: dto))
    }
  }

  func upload(userId id: Int64) {
    if case .loading = state {
      return
    }

    state = .loading
    let data = existedImageData + photoVM.attachments.map(\.data)

    let filenames = getExistedImageFilenames() + getPhotoFilenames()
    let mimeTypes = getExistedImageMimeTypes() + getPhotoMimeTypes()
    networking.upload(id: id, data: data, filenames: filenames, mimeTypes: mimeTypes)
      .sink { [weak self] response in
        guard let self else { return }
        handleUploadResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func getExistedImageFilenames() -> [String] {
    existedImageData.enumerated().map { i, _ in
      "\(i + 1).jpg"
    }
  }

  private func getExistedImageMimeTypes() -> [String] {
    existedImageData.enumerated().map { _, _ in
      defaultImageMimeType
    }
  }

  private func getPhotoFilenames() -> [String] {
    photoVM.selection.enumerated().map { i, item in
      let fileExtension = item.supportedContentTypes.first?
        .preferredFilenameExtension ?? ".jpg"
      return "\(existedImageData.count + i + 1).\(fileExtension)"
    }
  }

  private func getPhotoMimeTypes() -> [String] {
    photoVM.selection.map { item in
      item.supportedContentTypes.first?
        .preferredMIMEType ?? defaultImageMimeType
    }
  }

  private func handleUploadResponse(_ response: BusinessImagesUploadResponse) {
    debugPrint(response)
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status == 0 {
      if let urls = dto.data {
        imageUrls = urls
      }
      state = .uploadFinished
    } else {
      state = .failed(newNetworkError(response: dto))
    }
  }
}

extension BusinessImagesViewModel {
  enum State {
    case idle
    case loading
    case getFinished
    case uploadFinished
    case failed(NetworkError)
  }
}
