//
//  PostListNearbyViewModel.swift
//  locarie
//
//  Created by qiuty on 21/12/2023.
//

import Combine
import CoreLocation
import Foundation

final class PostListNearbyViewModel: BaseViewModel {
  @Published var posts: [PostDto] = []
  @Published var state: State = .idle

  private let networking: PostListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostListService = PostListServiceImpl.shared) {
    self.networking = networking
  }

  func getNearbyPosts(withLocation location: CLLocation) {
    getNearbyPosts(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
  }

  func getNearbyPosts(latitude: Double, longitude: Double) {
    networking.listNearbyPosts(
      latitude: latitude,
      longitude: longitude,
      distance: GlobalConstants.postsNearbyDistance
    )
    .sink { [weak self] response in
      guard let self else { return }
      handleResponse(response)
    }
    .store(in: &subscriptions)
  }

  private func handleResponse(_ response: PostListNearbyResponse) {
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      if dto.status != 0 {
        state = .failed(newNetworkError(response: dto))
      } else {
        if let data = dto.data {
          posts = data
        }
      }
    }
  }
}

extension PostListNearbyViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
