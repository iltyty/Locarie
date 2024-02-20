//
//  OpeningHoursEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct OpeningHoursEditPage: View {
  @Binding var businessHoursDtos: [BusinessHoursDto]

  @State var currentDayIndex = 0
  @State var isSheetPresented = false
  @State var allBusinessHours = allBusinessHoursDtos()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      navigationBar
      days
      Spacer()
    }
    .onAppear {
      setBusinessHours()
    }
    .sheet(isPresented: $isSheetPresented) { [currentDayIndex] in
      openingHourSheet(index: currentDayIndex)
    }
  }

  private func setBusinessHours() {
    if !businessHoursDtos.isEmpty {
      allBusinessHours = businessHoursDtos
    }
  }
}

private extension OpeningHoursEditPage {
  var navigationBar: some View {
    NavigationTitle("Edit opening hours", right: doneButton, divider: true)
      .padding(.bottom)
  }

  var doneButton: some View {
    Button("Done") {
      setBusinessHoursDtos()
      dismiss()
    }
    .fontWeight(.bold)
    .foregroundStyle(Color.locariePrimary)
  }

  var days: some View {
    VStack(spacing: Constants.vSpacing) {
      ForEach(allBusinessHours.indices, id: \.self) { index in
        BusinessHoursItem(allBusinessHours[index])
          .onTapGesture {
            currentDayIndex = index
            isSheetPresented = true
          }
      }
    }
    .padding(.horizontal)
  }

  var sortedDays: [BusinessHoursDto.DayOfWeek] {
    BusinessHoursDto.DayOfWeek.allCases.sorted()
  }

  func openingHourSheet(index: Int) -> some View {
    let title = allBusinessHours[index].dayOfWeek.rawValue.capitalized
    return OpeningHourSheet(
      title: title,
      isPresented: $isSheetPresented,
      businessHours: binding(for: index)
    )
    .presentationDetents([.fraction(Constants.sheetHeightFraction)])
    .padding(.horizontal)
  }
}

private extension OpeningHoursEditPage {
  func binding(for index: Int) -> Binding<BusinessHoursDto> {
    .init(
      get: { allBusinessHours[index] },
      set: { allBusinessHours[index] = $0 }
    )
  }

  func setBusinessHoursDtos() {
    businessHoursDtos.removeAll()
    for hours in allBusinessHours {
      businessHoursDtos.append(hours)
    }
  }
}

struct BusinessHoursItem: View {
  let businessHours: BusinessHoursDto

  init(_ businessHours: BusinessHoursDto) {
    self.businessHours = businessHours
  }

  var body: some View {
    HStack {
      Text(businessHours.dayOfWeek.rawValue)
      Spacer()
      Text(businessHours.formattedTime).foregroundStyle(.secondary)
      Image(systemName: "square.and.pencil")
        .foregroundStyle(.secondary)
    }
  }
}

private func allBusinessHoursDtos() -> [BusinessHoursDto] {
  BusinessHoursDto.DayOfWeek.allCases.sorted().map { dayOfWeek in
    BusinessHoursDto(dayOfWeek: dayOfWeek)
  }
}

private enum Constants {
  static let vSpacing = 40.0
  static let sheetHeightFraction = 0.4
}

#Preview {
  OpeningHoursEditPage(businessHoursDtos: .constant([]))
}
