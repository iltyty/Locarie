//
//  PostListNearbyAllViewModel.swift
//  locarie
//
//  Created by qiuty on 01/06/2024.
//

import Combine
import CoreLocation
import Foundation

final class PostListNearbyAllViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var posts: [PostDto] = []

  private var networking: PostListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostListService = PostListServiceImpl.shared) {
    self.networking = networking
  }

  func getNearbyAllPosts(with location: CLLocationCoordinate2D) {
    state = .loading
    networking.listPostsNearbyAll(latitude: location.latitude, longitude: location.longitude)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }

  func handleResponse(_ response: PostListResponse) {
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

extension PostListNearbyAllViewModel {
  enum State {
    case idle, loading, finished, failed(NetworkError)

    func isIdle() -> Bool {
      switch self {
      case .idle: true
      default: false
      }
    }

    func isLoading() -> Bool {
      switch self {
      case .loading: true
      default: false
      }
    }

    func isFinished() -> Bool {
      switch self {
      case .finished: true
      default: false
      }
    }

    func isLoaded() -> Bool {
      switch self {
      case .idle: false
      case .loading: false
      case .finished: true
      case .failed: true
      }
    }
  }
}
