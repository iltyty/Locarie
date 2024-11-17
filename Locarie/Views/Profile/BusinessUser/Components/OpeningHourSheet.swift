//
//  OpeningHourSheet.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct OpeningHourSheet: View {
  let title: String
  let openingTimeIndex: Int

  @Binding var isPresented: Bool
  @Binding var businessHours: BusinessHoursDto

  @State var closed = false
  @State var openingTime = Date()
  @State var closingTime = Date()

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      sheetTitle
      sheetCaption
      statusPicker
      statusContent
      buttons
    }
    .onAppear {
      setupStates()
    }
  }

  func setupStates() {
    closed = businessHours.closed
    let calendar = Calendar.current
    if openingTimeIndex < businessHours.openingHoursCount, let date = calendar.date(from: businessHours.openingTime[openingTimeIndex]) {
      openingTime = date
    }
    if openingTimeIndex < businessHours.openingHoursCount, let date = calendar.date(from: businessHours.closingTime[openingTimeIndex]) {
      closingTime = date
    }
  }
}

private extension OpeningHourSheet {
  var sheetTitle: some View {
    Text(title).fontWeight(.bold)
  }

  var sheetCaption: some View {
    HStack {
      Text("Status of your business on this day")
        .foregroundStyle(.secondary)
      Spacer()
    }
  }

  var statusPicker: some View {
    Picker("Status", selection: $closed) {
      Text("Open").tag(false)
      Text("Closed").tag(true)
    }
    .pickerStyle(.segmented)
  }

  var statusContent: some View {
    Group {
      if closed {
        Text("Closed").foregroundStyle(LocarieColor.greyDark)
      } else {
        timePicker
      }
    }
    .frame(height: Constants.statusContentHeight)
  }
}

private extension OpeningHourSheet {
  var timePicker: some View {
    VStack {
      LocarieDivider()
      HStack {
        Spacer()
        startTimePicker
        Spacer()
        endTimePicker
        Spacer()
      }
      LocarieDivider()
    }
    .labelsHidden()
    .datePickerStyle(.compact)
  }

  var startTimePicker: some View {
    DatePicker(
      "Opening time",
      selection: $openingTime,
      in: ...closingTime,
      displayedComponents: [.hourAndMinute]
    )
  }

  var endTimePicker: some View {
    DatePicker(
      "Closing time",
      selection: $closingTime,
      in: openingTime...,
      displayedComponents: [.hourAndMinute]
    )
  }
}

private extension OpeningHourSheet {
  var buttons: some View {
    HStack {
      Spacer()
      cancelButton
      Spacer()
      doneButton
      Spacer()
    }
  }

  var cancelButton: some View {
    Button("Cancel") {
      isPresented = false
    }
    .foregroundStyle(LocarieColor.greyDark)
  }

  var doneButton: some View {
    Button("Done") {
      setDailyHours()
      isPresented = false
    }
    .foregroundStyle(Color.locariePrimary)
  }

  func setDailyHours() {
    let calendar = Calendar.current
    
    if closed {
      if openingTimeIndex == 0 {
        businessHours.closed = closed
      } else {
        businessHours.openingTime.remove(at: 1)
        businessHours.closingTime.remove(at: 1)
      }
      return
    }
    
    if openingTimeIndex == 1 {
      businessHours.openingTime[0] = calendar.dateComponents([.hour, .minute], from: openingTime)
      businessHours.closingTime[0] = calendar.dateComponents([.hour, .minute], from: closingTime)
    }
    businessHours.openingTime[openingTimeIndex] = calendar.dateComponents(
      [.hour, .minute],
      from: openingTime
    )
    businessHours.closingTime[openingTimeIndex] = calendar.dateComponents(
      [.hour, .minute],
      from: closingTime
    )
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let statusContentHeight = 64.0
}
