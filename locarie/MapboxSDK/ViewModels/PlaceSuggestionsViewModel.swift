//
//  PlaceSuggestionsViewModel.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Combine
import CoreLocation
import Foundation

final class PlaceSuggestionsViewModel: ObservableObject {
  @Published var place = ""
  @Published var state: State = .idle

  private let networking: MapboxService
  private var subscriptions: Set<AnyCancellable> = []

  private let debounceInterval: DispatchQueue.SchedulerTimeType
    .Stride = .seconds(0.5)

  init(networking: MapboxService = MapboxServiceImpl.shared) {
    self.networking = networking
  }

  func listenToSearch(withOrigin origin: CLLocationCoordinate2D?) {
    $place.removeDuplicates()
      .debounce(for: debounceInterval, scheduler: DispatchQueue.main)
      .sink { query in
        if !query.isEmpty {
          self.getPlaceSuggestions(withOrigin: origin)
        } else {
          self.state = .idle
        }
      }
      .store(in: &subscriptions)
  }

  func getPlaceSuggestions(withOrigin origin: CLLocationCoordinate2D?) {
    networking.getPlaceSuggestions(forPlace: place, withOrigin: origin)
      .sink { completion in
        switch completion {
        case let .failure(error):
          debugPrint(error)
          if error.isSessionTaskError {
            self.state = .failed(.noInternet)
          }
        case .finished:
          break
        }
      } receiveValue: { value in
        self.state = .loaded(value.suggestions)
      }
      .store(in: &subscriptions)
  }
}

extension PlaceSuggestionsViewModel {
  enum State {
    case idle
    case loading
    case loaded([PlaceSuggestionDto])
    case failed(MapboxError)
  }
}
