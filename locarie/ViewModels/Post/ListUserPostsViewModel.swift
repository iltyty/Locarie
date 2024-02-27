//
//  ListUserPostsViewModel.swift
//  locarie
//
//  Created by qiuty on 05/02/2024.
//

import Combine
import Foundation

final class ListUserPostsViewModel: BaseViewModel {
  @Published var posts: [PostDto] = []
  @Published var state: State = .idle

  private let networking: PostListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: PostListService = PostListServiceImpl.shared) {
    self.networking = networking
  }

  func getUserPosts(id: Int64) {
    networking.listUserPosts(id: id)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleResponse(_ response: PostListResponse) {
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      if dto.status != 0 {
        state = .failed(newNetworkError(response: dto))
      } else {
        state = .finished
        if let dtos = dto.data {
          posts = dtos
        }
      }
    }
  }
}

extension ListUserPostsViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
