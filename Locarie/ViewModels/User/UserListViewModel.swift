//
//  UserListViewModel.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

import Combine
import CoreLocation
import Foundation

final class UserListViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var businesses: [UserDto] = []
  @Published var allBusinesses: [UserLocationDto] = []

  private var page = 0
  private var pageSize = 10
  private var allFetched = false
  private let networking: UserListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: UserListService = UserListServiceImpl.shared, size: Int = 10) {
    self.pageSize = size
    self.networking = networking
  }

  func listBusinesses(with location: CLLocationCoordinate2D, name: String = "") {
    if allFetched { return }
    if businesses.isEmpty {
      state = .loading
    }
    networking.listBusinesses(latitude: location.latitude, longitude: location.longitude, name: name, page: page, size: pageSize)
      .sink { [weak self] response in
        guard let self else { return }
        handleListBusinessesResponse(response)
      }
      .store(in: &subscriptions)
  }
  
  func listAllBusinesses() {
    state = .loadingAllBusinesses
    networking.listAllBusinesses()
      .sink { [weak self] response in
        guard let self else { return }
        handleListAllBusinessesResponse(response)
      }
      .store(in: &subscriptions)
  }
  
  func clear() {
    page = 0
    allFetched = false
    businesses = []
    allBusinesses = []
  }

  private func handleListBusinessesResponse(_ response: ListBusinessesResponse) {
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
    businesses.append(contentsOf: dto.data.content.filter(\.isProfileComplete))
    state = .finished
  }
  
  private func handleListAllBusinessesResponse(_ response: ListAllBusinessesResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    if let result = dto.data {
      // shuffled for random icon z-index on map
      allBusinesses = result.shuffled()
    }
    state = .finished
  }
}

extension UserListViewModel {
  enum State {
    case idle
    case loading
    case loadingAllBusinesses
    case finished
    case failed(NetworkError)
    
    func isIdle() -> Bool {
      return switch self {
      case .idle: true
      default: false
      }
    }
    
    func isLoading() -> Bool {
      return switch self {
      case .loading: true
      default: false
      }
    }
    
    func isLoadingAllBusinesses() -> Bool {
      return switch self {
      case .loadingAllBusinesses: true
      default: false
      }
    }
    
    func isFinished() -> Bool {
      return switch self {
      case .finished: true
      default: false
      }
    }
  }
}
