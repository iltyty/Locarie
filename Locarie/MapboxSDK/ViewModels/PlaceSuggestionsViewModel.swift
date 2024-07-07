//
//  PlaceSuggestionsViewModel.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import Alamofire
import Combine
import CoreLocation
import Foundation

public final class PlaceSuggestionsViewModel: ObservableObject {
  @Published var place = ""
  @Published var debouncedPlace = ""
  @Published var state: State = .idle

  private let networking: MapboxSuggestionService
  private var subscriptions: Set<AnyCancellable> = []

  private let debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .seconds(0.5)

  init(networking: MapboxSuggestionService = MapboxSuggestionServiceImpl.shared) {
    self.networking = networking
    debouncePlace()
  }

  private func debouncePlace() {
    $place.removeDuplicates()
      .debounce(for: debounceInterval, scheduler: DispatchQueue.main)
      .sink { [weak self] value in
        guard let self else { return }
        debouncedPlace = value
      }
      .store(in: &subscriptions)
  }

  func listenToSearch() {
    $debouncedPlace
      .sink { [weak self] query in
        guard let self else { return }
        switch state {
        case .chosen:
          state = .idle
        default:
          if !query.isEmpty {
            getPlaceSuggestions()
          } else {
            state = .idle
          }
        }
      }
      .store(in: &subscriptions)
  }

  func getPlaceSuggestions() {
    networking.getPlaceSuggestions(forPlace: place, withOrigin: nil)
      .sink { [weak self] completion in
        guard let self else { return }
        handleSinkCompletion(completion)
      } receiveValue: { [weak self] value in
        guard let self else { return }
        handleSinkValue(value)
      }
      .store(in: &subscriptions)
  }

  private func handleSinkCompletion(_ completion: Subscribers.Completion<AFError>) {
    switch completion {
    case let .failure(error):
      debugPrint(error)
      if error.isSessionTaskError {
        state = .failed(.noInternet)
      } else {
        state = .failed(.unknown(error))
      }
    case .finished:
      return
    }
  }

  private func handleSinkValue(_ value: PlaceSuggestionsResponseDto) {
    state = .loaded(value.suggestions)
  }

  func choose(_ place: PlaceSuggestionDto) {
    state = .chosen(place)
    self.place = place.name
  }
}

public extension PlaceSuggestionsViewModel {
  enum State {
    case idle
    case loading
    case loaded([PlaceSuggestionDto])
    case chosen(PlaceSuggestionDto)
    case failed(MapboxError)
  }
}
