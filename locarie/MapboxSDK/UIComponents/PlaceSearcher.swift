//
//  PlaceSearcher.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import CoreLocation
import SwiftUI

struct PlaceSearcher: View {
  @ObservedObject var vm: PlaceSuggestionsViewModel
  var hint = "Search places"

  @State private var loading = false
  @FocusState private var inputting: Bool

  private let origin: CLLocationCoordinate2D? = nil

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        searchIcon
        textInput
      }
      .frame(height: Constants.height)
      .background {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .stroke(LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
          .padding(0.75)
      }
      if case let .loaded(suggestions) = vm.state, inputting {
        VStack(alignment: .leading) {
          List {
            ForEach(suggestions, id: \.self) { suggestion in
              PlaceSuggestionItem(suggestion)
                .onTapGesture { vm.choose(suggestion) }
            }
          }
          .listStyle(.plain)
        }
        .loadingIndicator(loading: $loading)
      }
    }
    .onAppear { vm.listenToSearch(withOrigin: origin) }
    .onReceive(vm.$state) { state in
      if case .loading = state {
        loading = true
      } else {
        loading = false
      }
    }
  }

  private var searchIcon: some View {
    Image(systemName: "magnifyingglass")
      .padding([.leading])
      .padding([.trailing], Constants.iconPadding)
  }

  private var textInput: some View {
    TextField(hint, text: $vm.place)
      .focused($inputting)
      .tint(LocarieColor.greyDark)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.never)
  }
}

private enum Constants {
  static let height = 48.0
  static let padding = 20.0
  static let iconPadding = 10.0
  static let cornerRadius = 25.0
}

#Preview {
  PlaceSearcher(vm: PlaceSuggestionsViewModel())
}
