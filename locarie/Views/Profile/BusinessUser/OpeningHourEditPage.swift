//
//  OpeningHourEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct OpeningHourEditPage: View {
  @State var isSheetPresented = false
  @State var currentKey: DailyHours.Day = .Sunday
  @State var allDailyHours = defaultDailyHoursDict()

  var body: some View {
    VStack {
      navigationTitle
      days
    }
    .sheet(isPresented: $isSheetPresented) { [currentKey] in
      openingHourSheet(key: currentKey)
    }
  }
}

private extension OpeningHourEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit opening hours")
  }

  var days: some View {
    List {
      ForEach(sortedDays, id: \.self) { key in
        let dailyHours = allDailyHours[key]!
        DayItem(dailyHours)
          .onTapGesture {
            currentKey = key
            isSheetPresented = true
          }
      }
    }
    .listStyle(.plain)
    .listRowSpacing(Constants.listVSpacing)
  }

  var sortedDays: [DailyHours.Day] {
    Array(allDailyHours.keys)
      .sorted()
  }

  func openingHourSheet(key: DailyHours.Day) -> some View {
    let title = allDailyHours[key]!.day.rawValue.capitalized
    return OpeningHourSheet(
      title: title,
      isPresented: $isSheetPresented,
      dailyHours: binding(for: key)
    )
    .presentationDetents([.fraction(Constants.sheetHeightFraction)])
    .padding(.horizontal)
  }
}

private extension OpeningHourEditPage {
  func binding(for key: DailyHours.Day) -> Binding<DailyHours> {
    .init(
      get: { allDailyHours[key]! },
      set: { allDailyHours[key] = $0 }
    )
  }
}

struct DayItem: View {
  let dailyHours: DailyHours

  init(_ dailyHours: DailyHours) {
    self.dailyHours = dailyHours
  }

  var body: some View {
    HStack {
      Text(dailyHours.day.rawValue)
      Spacer()
      Text(dailyHours.formattedTime).foregroundStyle(.secondary)
      Image(systemName: "square.and.pencil")
        .foregroundStyle(.secondary)
    }
  }
}

private func defaultDailyHoursDict() -> [DailyHours.Day: DailyHours] {
  Dictionary(uniqueKeysWithValues: DailyHours.Day.allCases.map {
    ($0, DailyHours(day: $0))
  })
}

private enum Constants {
  static let listVSpacing = 10.0
  static let sheetHeightFraction = 0.4
}

#Preview {
  OpeningHourEditPage()
}
