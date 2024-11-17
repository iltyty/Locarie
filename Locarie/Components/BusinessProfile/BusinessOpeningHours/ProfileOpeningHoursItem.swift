//
//  ProfileOpeningHoursItem.swift
//  locarie
//
//  Created by qiuty on 27/02/2024.
//

import SwiftUI

struct ProfileOpeningHoursItem: View {
  let editable: Bool
  let hours: BusinessHoursDto
  var onFirstOpeningTimeTapped: () -> Void
  var onSecondOpeningTimeTapped: () -> Void
  
  init(
    _ hours: BusinessHoursDto,
    editable: Bool = false,
    onFirstOpeningTimeTapped: @escaping () -> Void = {},
    onSecondOpeningTimeTapped: @escaping () -> Void = {}
  ) {
    self.hours = hours
    self.editable = editable
    self.onFirstOpeningTimeTapped = onFirstOpeningTimeTapped
    self.onSecondOpeningTimeTapped = onSecondOpeningTimeTapped
  }
  
  var body: some View {
    HStack(alignment: .top) {
      Text(hours.dayOfWeek.rawValue)
      Spacer()
      VStack(alignment: .trailing, spacing: 12) {
        HStack(spacing: 24) {
          VStack(spacing: 8) {
            Text(hours.formattedTime(0)).foregroundStyle(LocarieColor.greyDark)
            if !editable && hours.openingHoursCount > 1 {
              Text(hours.formattedTime(1)).foregroundStyle(LocarieColor.greyDark)
            }
          }
          if editable {
            editIcon
          }
        }
        .onTapGesture {
          onFirstOpeningTimeTapped()
        }
        HStack(spacing: 24) {
          if editable {
            Group {
              if hours.openingHoursCount == 1 {
                Text("optional").foregroundStyle(LocarieColor.greyDark)
              } else {
                Text(hours.formattedTime(1)).foregroundStyle(LocarieColor.greyDark)
              }
              editIcon
            }
            .onTapGesture {
              onSecondOpeningTimeTapped()
            }
          }
        }
      }
    }
  }
  
  private var editIcon: some View {
    Image("Pencil.Grey")
      .resizable()
      .scaledToFit()
      .frame(size: 16)
  }
}

#Preview {
  ProfileOpeningHoursItem(BusinessHoursDto(dayOfWeek: .Friday))
}
