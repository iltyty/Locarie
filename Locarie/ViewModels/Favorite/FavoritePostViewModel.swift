//
//  FavoritePostViewModel.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import Combine
import Foundation

final class FavoritePostViewModel: BaseViewModel {
  @Published var alreadySaved = false
  @Published var posts: [PostDto] = []
  @Published var state: State = .idle


  private var page = 0
  private var pageSize = 10
  private var allFetched = false
  private let networking: FavoritePostService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: FavoritePostService = FavoritePostServiceImpl.shared, size: Int = 10) {
    self.pageSize = size
    self.networking = networking
  }
  
  func reset() {
    page = 0
    allFetched = false
    posts = []
  }
}

extension FavoritePostViewModel {
  func favorite(userId: Int64, postId: Int64) {
    state = .loading
    networking.favorite(userId: userId, postId: postId)
      .sink { [weak self] response in
        guard let self else { return }
        handleFavoriteResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleFavoriteResponse(
    _ response: FavoritePostResponse
  ) {
    if let error = response.error {
      state = .favoriteFailed(error)
    } else {
      let dto = response.value!
      if dto.status == 0 {
        state = .favoriteFinished
      } else {
        state = .favoriteFailed(newNetworkError(response: dto))
      }
    }
  }
}

extension FavoritePostViewModel {
  func unfavorite(userId: Int64, postId: Int64) {
    state = .loading
    networking.unfavorite(userId: userId, postId: postId)
      .sink { [weak self] response in
        guard let self else { return }
        handleUnfavoriteResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleUnfavoriteResponse(
    _ response: UnfavoritePostResponse
  ) {
    if let error = response.error {
      state = .unfavoriteFailed(error)
    } else {
      let dto = response.value!
      if dto.status == 0 {
        state = .unfavoriteFinished
      } else {
        state = .unfavoriteFailed(newNetworkError(response: dto))
      }
    }
  }
}

extension FavoritePostViewModel {
  func list(userId: Int64) {
    if allFetched { return }
    if posts.isEmpty {
      state = .loading
    }
    networking.list(userId: userId, page: page, size: pageSize)
      .sink { [weak self] response in
        guard let self else { return }
        handleListResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleListResponse(
    _ response: ListFavoritePostsResponse
  ) {
    if let error = response.error {
      state = .listFailed(error)
      return
    }
    
    let dto = response.value!
    if dto.status != 0 {
      state = .listFailed(newNetworkError(response: dto))
      return
    }
    
    allFetched = dto.data.last
    if !allFetched {
      page += 1
    }
    posts.append(contentsOf: dto.data.content)
    state = .listFinished
  }
}

extension FavoritePostViewModel {
  func checkFavoredBy(userId: Int64, postId: Int64) {
    state = .loading
    networking.isFavoredBy(userId: userId, postId: postId)
      .sink { [weak self] response in
        guard let self else { return }
        handleCheckResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleCheckResponse(
    _ response: PostIsFavoredByResponse
  ) {
    if let error = response.error {
      state = .checkFailed(error)
    } else {
      let dto = response.value!
      if dto.status == 0 {
        if let data = dto.data {
          alreadySaved = data
        }
        state = .checkFinished
      } else {
        state = .checkFailed(newNetworkError(response: dto))
      }
    }
  }
}

extension FavoritePostViewModel {
  enum State {
    case idle
    case loading
    case favoriteFinished
    case unfavoriteFinished
    case listFinished
    case checkFinished
    case favoriteFailed(NetworkError)
    case unfavoriteFailed(NetworkError)
    case listFailed(NetworkError)
    case checkFailed(NetworkError)
  }
}
