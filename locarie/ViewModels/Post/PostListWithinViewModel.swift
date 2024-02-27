//
//  PostListWithinViewModel.swift
//  locarie
//
//  Created by qiuty on 27/02/2024.
//

import Combine
import Foundation

final class PostListWithinViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var posts: [PostDto] = []

  private let networking: PostListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostListService = PostListServiceImpl.shared) {
    self.networking = networking
  }

  func list(
    _ minLatitude: Double, _ maxLatitude: Double,
    _ minLongitude: Double, _ maxLongitude: Double
  ) {
    list(PostListWithinRequestDto(
      minLatitude: minLatitude, maxLatitude: maxLatitude,
      minLongitude: minLongitude, maxLongitude: maxLongitude
    ))
  }

  func list(_ request: PostListWithinRequestDto) {
    state = .loading
    networking.listPostsWithin(request)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleResponse(_ response: PostListResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    if let data = dto.data {
      posts = data
    }
    state = .finished
  }
}

extension PostListWithinViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
