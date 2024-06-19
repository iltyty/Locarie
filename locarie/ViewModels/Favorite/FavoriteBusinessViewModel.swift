//
//  FavoriteBusinessViewModel.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import Combine

final class FavoriteBusinessViewModel: BaseViewModel {
  @Published var alreadyFollowed = false
  @Published var users: [UserDto] = []
  @Published var state: State = .idle
  @Published var posts: [PostDto] = []

  let networking: FavoriteBusinessService

  var subscriptions: Set<AnyCancellable> = []

  init(
    _ networking: FavoriteBusinessService = FavoriteBusinessServiceImpl.shared
  ) {
    self.networking = networking
  }
}

extension FavoriteBusinessViewModel {
  func favorite(userId: Int64, businessId: Int64) {
    state = .loading
    networking.favorite(userId: userId, businessId: businessId)
      .sink { [weak self] response in
        guard let self else { return }
        handleFavoriteResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleFavoriteResponse(
    _ response: FavoriteBusinessResponse
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

extension FavoriteBusinessViewModel {
  func unfavorite(userId: Int64, businessId: Int64) {
    state = .loading
    networking.unfavorite(userId: userId, businessId: businessId)
      .sink { [weak self] response in
        guard let self else { return }
        handleUnfavoriteResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleUnfavoriteResponse(
    _ response: UnfavoriteBusinessResponse
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

extension FavoriteBusinessViewModel {
  func list(userId: Int64) {
    state = .loading
    networking.list(userId: userId)
      .sink { [weak self] response in
        guard let self else { return }
        handleListResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleListResponse(
    _ response: ListFavoriteBusinessesResponse
  ) {
    if let error = response.error {
      state = .listFailed(error)
    } else {
      let dto = response.value!
      if dto.status == 0 {
        if let data = dto.data {
          users = data
        }
        state = .listFinished
      } else {
        state = .listFailed(newNetworkError(response: dto))
      }
    }
  }
}

extension FavoriteBusinessViewModel {
  func checkFavoredBy(userId: Int64, businessId: Int64) {
    state = .loading
    networking.isFavoredBy(userId: userId, businessId: businessId)
      .sink { [weak self] response in
        guard let self else { return }
        handleCheckResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleCheckResponse(_ response: BusinessIsFavoredByResponse) {
    if let error = response.error {
      state = .checkFailed(error)
      return
    }
    let dto = response.value!
    if dto.status == 0 {
      if let data = dto.data {
        alreadyFollowed = data
      }
      state = .checkFinished
    } else {
      state = .checkFailed(newNetworkError(response: dto))
    }
  }
}

extension FavoriteBusinessViewModel {
  func listFavoriteBusinessPosts(userId: Int64) {
    state = .loading
    networking.listFavoriteBusinessPosts(userId: userId)
      .sink { [weak self] response in
        guard let self else { return }
        handleListPostsResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleListPostsResponse(_ response: ListFavoriteBusinessPostsResponse) {
    debugPrint(response)
    if let error = response.error {
      state = .listPostsFailed(error)
      return
    }
    let dto = response.value!
    if dto.status == 0 {
      if let data = dto.data {
        posts = data
      }
      state = .listPostsFinished
    } else {
      state = .listPostsFailed(newNetworkError(response: dto))
    }
  }
}

extension FavoriteBusinessViewModel {
  enum State {
    case idle
    case loading
    case favoriteFinished
    case unfavoriteFinished
    case listFinished
    case listPostsFinished
    case checkFinished
    case favoriteFailed(NetworkError)
    case unfavoriteFailed(NetworkError)
    case listFailed(NetworkError)
    case listPostsFailed(NetworkError)
    case checkFailed(NetworkError)
  }
}
