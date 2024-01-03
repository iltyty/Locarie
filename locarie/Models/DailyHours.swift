//
//  DailyHours.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation

struct DailyHours: Sendable {
  var day: Day
  var startTime = Date()
  var endTime = Date()
  var status: Status = .closed

  var timeFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
  }

  var formattedStartTime: String {
    timeFormatter.string(from: startTime)
  }

  var formattedEndTime: String {
    timeFormatter.string(from: endTime)
  }

  var formattedTime: String {
    switch status {
    case .open: "\(formattedStartTime)-\(formattedEndTime)"
    case .closed: "Closed"
    }
  }
}

extension DailyHours {
  enum Day: String, Sendable, CaseIterable, Comparable {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday

    private var sortOrder: Int {
      switch self {
      case .Sunday: 0
      case .Monday: 1
      case .Tuesday: 2
      case .Wednesday: 3
      case .Thursday: 4
      case .Friday: 5
      case .Saturday: 6
      }
    }

    static func == (lhs: Day, rhs: Day) -> Bool {
      lhs.sortOrder == rhs.sortOrder
    }

    static func < (lhs: Day, rhs: Day) -> Bool {
      lhs.sortOrder < rhs.sortOrder
    }
  }
}

extension DailyHours {
  enum Status: String, Hashable, CaseIterable {
    case open, closed
  }
}
