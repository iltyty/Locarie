//
//  OpeningHourSheet.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct OpeningHourSheet: View {
  let title: String

  @Binding var isPresented: Bool
  @Binding var dailyHours: DailyHours

  @State var startTime = Date()
  @State var endTime = Date()
  @State var status: DailyHours.Status = .closed

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
    startTime = dailyHours.startTime
    endTime = dailyHours.endTime
    status = dailyHours.status
  }
}

private extension OpeningHourSheet {
  var sheetTitle: some View {
    Text(title).font(.headline)
  }

  var sheetCaption: some View {
    HStack {
      Text("Status of your business on this day")
        .foregroundStyle(.secondary)
      Spacer()
    }
  }

  var statusPicker: some View {
    Picker("Status", selection: $status) {
      ForEach(DailyHours.Status.allCases, id: \.self) { status in
        Text(status.rawValue.capitalized)
      }
    }
    .pickerStyle(.segmented)
  }

  var statusContent: some View {
    Group {
      switch status {
      case .open: openView
      case .closed: closedView
      }
    }
    .frame(height: Constants.statusContentHeight)
  }

  var openView: some View {
    timePicker
  }

  var closedView: some View {
    Text("Closed")
      .foregroundStyle(.secondary)
  }
}

private extension OpeningHourSheet {
  var timePicker: some View {
    VStack {
      Divider()
      HStack {
        Spacer()
        startTimePicker
        Spacer()
        endTimePicker
        Spacer()
      }
      Divider()
    }
    .labelsHidden()
    .datePickerStyle(.compact)
  }

  var startTimePicker: some View {
    DatePicker(
      "Opening time",
      selection: $startTime,
      in: ...endTime,
      displayedComponents: [.hourAndMinute]
    )
  }

  var endTimePicker: some View {
    DatePicker(
      "Closing time",
      selection: $endTime,
      in: startTime...,
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
    .foregroundStyle(.secondary)
  }

  var doneButton: some View {
    Button("Done") {
      isPresented = false
      setDailHours()
    }
    .foregroundStyle(Color.locariePrimary)
  }

  func setDailHours() {
    dailyHours.status = status
    dailyHours.startTime = startTime
    dailyHours.endTime = endTime
  }
}

private enum Constants {
  static let vSpacing = 24.0
  static let statusContentHeight = 64.0
}
