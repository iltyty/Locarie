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

  private var page = 0
  private var pageSize = 10
  private var allFetched = false
  private var networking: PostListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostListService = PostListServiceImpl.shared, size: Int = 10) {
    self.pageSize = size
    self.networking = networking
  }

  func getNearbyAllPosts(with location: CLLocationCoordinate2D) {
    if allFetched { return }
    if posts.isEmpty {
      state = .loading
    }
    networking.listPostsNearbyAll(latitude: location.latitude, longitude: location.longitude, page: page, size: pageSize)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }

  func handleResponse(_ response: PaginatedPostListResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    page += 1
    allFetched = dto.data.last
    posts.append(contentsOf: dto.data.content)
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
