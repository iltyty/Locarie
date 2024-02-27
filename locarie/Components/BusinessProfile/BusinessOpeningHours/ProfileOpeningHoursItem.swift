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

  init(_ hours: BusinessHoursDto, editable: Bool = false) {
    self.hours = hours
    self.editable = editable
  }

  var body: some View {
    HStack {
      Text(hours.dayOfWeek.rawValue)
      Spacer()
      Text(hours.formattedTime).foregroundStyle(.secondary)
      if editable {
        Image(systemName: "square.and.pencil").foregroundStyle(.secondary)
      }
    }
  }
}
