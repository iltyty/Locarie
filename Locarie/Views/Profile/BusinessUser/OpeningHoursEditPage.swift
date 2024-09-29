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
  @State var openingTimeIndex = 0
  @State var isSheetPresented = false
  @State var allBusinessHours = BusinessHoursDto.all

  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      navigationBar
      VStack(spacing: Constants.vSpacing) {
        ForEach(allBusinessHours.indices, id: \.self) { index in
          ProfileOpeningHoursItem(
            allBusinessHours[index],
            editable: true,
            onFirstOpeningTimeTapped: {
              currentDayIndex = index
              openingTimeIndex = 0
              isSheetPresented = true
            },
            onSecondOpeningTimeTapped: {
              currentDayIndex = index
              openingTimeIndex = 1
              isSheetPresented = true
            }
          )
        }
      }
      .padding(.horizontal)
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
    NavigationBar("Edit opening hours", right: doneButton, divider: true)
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

  var sortedDays: [BusinessHoursDto.DayOfWeek] {
    BusinessHoursDto.DayOfWeek.allCases.sorted()
  }

  func openingHourSheet(index: Int) -> some View {
    let title = allBusinessHours[index].dayOfWeek.rawValue.capitalized
    return OpeningHourSheet(
      title: title,
      openingTimeIndex: openingTimeIndex,
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

private enum Constants {
  static let vSpacing = 40.0
  static let sheetHeightFraction = 0.4
}

private struct OpneingHoursEditPageTestView: View {
  @State var hours: [BusinessHoursDto] = []
  
  var body: some View {
    OpeningHoursEditPage(businessHoursDtos: $hours)
  }
}

#Preview {
  OpneingHoursEditPageTestView()
}
