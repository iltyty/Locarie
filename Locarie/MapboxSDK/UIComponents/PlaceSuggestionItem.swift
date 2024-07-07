//
//  PlaceSuggestionItem.swift
//  locarie
//
//  Created by qiuty on 26/12/2023.
//

import SwiftUI

struct PlaceSuggestionItem: View {
  private let suggestion: PlaceSuggestionDto
  private let divider: Bool

  init(_ suggestion: PlaceSuggestionDto, divider: Bool = true) {
    self.suggestion = suggestion
    self.divider = divider
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("\(suggestion.name)\(address)").lineLimit(1)
        Spacer()
      }
      if divider { LocarieDivider().padding(.top, 22) }
    }
  }

  private var address: String {
    if let fullAddress = suggestion.fullAddress {
      ", \(fullAddress)"
    } else {
      ""
    }
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
