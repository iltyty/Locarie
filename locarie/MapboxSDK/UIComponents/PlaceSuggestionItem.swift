//
//  PlaceSuggestionItem.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import SwiftUI

struct PlaceSuggestionItem: View {
  private let suggestion: PlaceSuggestionDto

  init(_ suggestion: PlaceSuggestionDto) {
    self.suggestion = suggestion
  }

  var body: some View {
    VStack(alignment: .leading) {
      name
      detail
    }
  }

  var name: some View {
    Text(suggestion.name)
  }

  var detail: some View {
    Text(suggestion.fullAddress ?? "")
      .lineLimit(1)
  }
}

#Preview {
  let suggestion = PlaceSuggestionDto(
    name: "Shreeji Newsagent",
    namePreferred: nil,
    mapboxId: "123456",
    address: "6 Chiltern St",
    fullAddress: "6 Chiltern St, London, W1U 7PT, United Kingdom",
    placeFormatted: "London, W1U 7PT, United Kingdom",
    distance: nil
  )
  return PlaceSuggestionItem(suggestion)
}
