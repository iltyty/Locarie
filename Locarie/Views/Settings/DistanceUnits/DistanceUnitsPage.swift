//
//  DistanceUnitsPage.swift
//  Locarie
//
//  Created by qiuty on 22/08/2024.
//

import SwiftUI

struct DistanceUnitsPage: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 24) {
      NavigationBar("Distance Units")
      VStack(spacing: 0) {
        LocarieDivider()
        buildDistanceUnit(text: "Kilometres", unit: .kilometres)
        LocarieDivider()
        buildDistanceUnit(text: "Miles", unit: .miles)
        LocarieDivider()
        Spacer()
      }
      .padding(.horizontal, 16)
    }
  }

  private func buildDistanceUnit(text: String, unit: DistanceUnits) -> some View {
    HStack {
      Text(text)
        .padding(.vertical, 20)
      Spacer()
      Circle()
        .fill(cacheVM.cache.distanceUnits == unit.rawValue ? LocarieColor.green : LocarieColor.greyMedium)
        .frame(size: 16)
        .onTapGesture {
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
          cacheVM.setDistanceUnits(unit)
        }
    }
  }
}

#Preview {
  DistanceUnitsPage()
}
