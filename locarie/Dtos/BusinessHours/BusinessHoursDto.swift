//
//  BusinessHoursDto.swift
//  locarie
//
//  Created by qiuty on 09/01/2024.
//

import Foundation

struct BusinessHoursDto: Codable, Identifiable {
  var id = 0
  var dayOfWeek: DayOfWeek
  var closed: Bool
  var openingTime: DateComponents
  var closingTime: DateComponents

  init(dayOfWeek: DayOfWeek) {
    self.dayOfWeek = dayOfWeek
    closed = true
    openingTime = DateComponents()
    openingTime.hour = 8
    openingTime.minute = 0
    closingTime = DateComponents()
    closingTime.hour = 21
    closingTime.minute = 0
  }
}

extension BusinessHoursDto {
  var formattedStatus: String {
    let dayOfWeekString = dayOfWeek.rawValue.capitalized
    return "\(dayOfWeekString): \(formattedTime)"
  }

  var formattedTime: String {
    closed ? "Closed" : "\(formattedOpeningTime)-\(formattedClosingTime)"
  }

  var formattedOpeningTime: String {
    dateComponentsFormatter.string(from: openingTime) ?? ""
  }

  var formattedClosingTime: String {
    dateComponentsFormatter.string(from: closingTime) ?? ""
  }

  var dateComponentsFormatter: DateComponentsFormatter {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.zeroFormattingBehavior = .pad
    return formatter
  }
}

extension BusinessHoursDto {
  enum DayOfWeek: String, Codable, Comparable, CaseIterable {
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

    static func == (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
      lhs.sortOrder == rhs.sortOrder
    }

    static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
      lhs.sortOrder < rhs.sortOrder
    }
  }

  static var all: [BusinessHoursDto] {
    DayOfWeek.allCases.sorted().map { dayOfWeek in
      BusinessHoursDto(dayOfWeek: dayOfWeek)
    }
  }
}
