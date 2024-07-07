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

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Image(systemName: "magnifyingglass")
          .padding(.leading, 16)
          .padding(.trailing, 14)
        TextField(hint, text: $vm.place)
          .tint(LocarieColor.greyDark)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
      }
      .frame(height: Constants.height)
      .background {
        Capsule()
          .stroke(LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
          .padding(0.75)
      }
      if case let .loaded(suggestions) = vm.state {
        VStack(alignment: .leading, spacing: 22) {
          ForEach(suggestions.indices, id: \.self) { i in
            PlaceSuggestionItem(suggestions[i], divider: i != suggestions.count - 1)
              .onTapGesture { vm.choose(suggestions[i]) }
          }
        }
        .padding(.top, 22)
      }
    }
    .loadingIndicator(loading: $loading)
    .onReceive(vm.$state) { state in
      if case .loading = state {
        loading = true
      } else {
        loading = false
      }
    }
    .onAppear { vm.listenToSearch() }
    .onDisappear {
      vm.state = .idle
      vm.place = ""
    }
  }
}

private enum Constants {
  static let height = 48.0
  static let cornerRadius = 25.0
}

#Preview {
  PlaceSearcher(vm: PlaceSuggestionsViewModel())
}
