//
//  PlaceSearcher.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import CoreLocation
import SwiftUI

struct PlaceSearcher: View {
  @ObservedObject var viewModel: PlaceSuggestionsViewModel

  private let origin: CLLocationCoordinate2D? = nil

  var body: some View {
    VStack {
      searchBar
      searchResult
    }
    .onAppear {
      viewModel.listenToSearch(withOrigin: origin)
    }
  }

  private var searchBar: some View {
    HStack {
      searchIcon
      textInput
    }
    .background(searchBarBackground)
    .padding()
  }

  @ViewBuilder
  private var searchResult: some View {
    if case let .loaded(suggestions) = viewModel.state {
      VStack(alignment: .leading) {
        List {
          ForEach(suggestions, id: \.self) { suggestion in
            PlaceSuggestionItem(suggestion)
              .onTapGesture {
                viewModel.choose(suggestion)
              }
          }
        }
        .listStyle(.plain)
      }
    } else {
      EmptyView()
    }
  }

  private var searchIcon: some View {
    Image(systemName: "magnifyingglass")
      .padding([.leading])
      .padding([.trailing], Constants.iconPadding)
  }

  private var textInput: some View {
    TextField("Search places", text: $viewModel.place)
      .autocorrectionDisabled()
      .textInputAutocapitalization(.never)
  }

  private var searchBarBackground: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .fill(.background)
      .frame(height: Constants.height)
      .shadow(color: .gray, radius: 2)
  }
}

private enum Constants {
  static let height = 50.0
  static let padding = 20.0
  static let iconPadding = 10.0
  static let cornerRadius = 25.0
}

#Preview {
  ZStack {
    Color.pink
    PlaceSearcher(viewModel: PlaceSuggestionsViewModel())
  }
}
