//
//  OpeningHoursEditPage.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct OpeningHoursEditPage: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel

  @State private var currentDayIndex = 0
  @State private var openingTimeIndex = 0
  @State private var isSheetPresented = false
  @State private var allBusinessHours = BusinessHoursDto.all

  @Environment(\.dismiss) private var dismiss
  
  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack {
      NavigationBar("Edit opening hours", right: doneButton, divider: true)
        .padding(.bottom)
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
      debugPrint(profileUpdateVM.dto)
      setBusinessHours()
    }
    .sheet(isPresented: $isSheetPresented) { [currentDayIndex] in
      openingHourSheet(index: currentDayIndex)
    }
  }

  private func setBusinessHours() {
    if !profileUpdateVM.dto.businessHours.isEmpty {
      allBusinessHours = profileUpdateVM.dto.businessHours
    }
  }
}

private extension OpeningHoursEditPage {
  var doneButton: some View {
    Button("Save") {
      setBusinessHoursDtos()
      profileUpdateVM.updateProfile(userId: cacheVM.getUserId())
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
    profileUpdateVM.dto.businessHours.removeAll()
    for hours in allBusinessHours {
      profileUpdateVM.dto.businessHours.append(hours)
    }
  }
}

private enum Constants {
  static let vSpacing = 40.0
  static let sheetHeightFraction = 0.4
}
