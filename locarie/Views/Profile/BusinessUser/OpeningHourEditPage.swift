//
//  OpeningHourEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct OpeningHourEditPage: View {
  @Binding var businessHoursDtos: [BusinessHoursDto]

  @State var currentDayIndex = 0
  @State var isSheetPresented = false
  @State var allBusinessHours = allBusinessHoursDtos()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      navigationTitle
      days
    }
    .onAppear {
      setBusinessHours()
    }
    .sheet(isPresented: $isSheetPresented) { [currentDayIndex] in
      openingHourSheet(index: currentDayIndex)
    }
  }

  private func setBusinessHours() {
    allBusinessHours = businessHoursDtos
  }
}

private extension OpeningHourEditPage {
  var navigationTitle: some View {
    NavigationTitle("Edit opening hours", right: doneButton)
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
    List {
      ForEach(allBusinessHours.indices, id: \.self) { index in
        BusinessHoursItem(allBusinessHours[index])
          .onTapGesture {
            currentDayIndex = index
            isSheetPresented = true
          }
      }
    }
    .listStyle(.plain)
    .listRowSpacing(Constants.listVSpacing)
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

private extension OpeningHourEditPage {
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
  static let listVSpacing = 10.0
  static let sheetHeightFraction = 0.4
}

#Preview {
  OpeningHourEditPage(businessHoursDtos: .constant([]))
}
