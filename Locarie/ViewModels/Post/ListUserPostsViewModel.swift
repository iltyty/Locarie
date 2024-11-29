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
  
  private var page = 0
  private var pageSize = 10
  private var allFetched = false
  private let networking: PostListService
  private var subscriptions: Set<AnyCancellable> = []
  
  init(_ networking: PostListService = PostListServiceImpl.shared, size: Int = 10) {
    self.pageSize = size
    self.networking = networking
  }
  
  func reset() {
    page = 0
    allFetched = false
    posts = []
  }
  
  func getUserPosts(id: Int64) {
    if allFetched { return }
    if posts.isEmpty {
      state = .loading
    }
    networking.listUserPosts(id: id, page: page, size: pageSize)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response)
      }
      .store(in: &subscriptions)
  }
  
  private func handleResponse(_ response: PaginatedPostListResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    allFetched = dto.data.last
    if !allFetched {
      page += 1
    }
    posts.append(contentsOf: dto.data.content)
    state = .finished
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
