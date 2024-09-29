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
  var openingTime: [DateComponents]
  var closingTime: [DateComponents]

  init(dayOfWeek: DayOfWeek) {
    self.dayOfWeek = dayOfWeek
    closed = true
    openingTime = []
    closingTime = []
  }
}

extension BusinessHoursDto {
  var formattedStatus: String {
    var res = "\(dayOfWeek.rawValue.capitalized): "
    let cnt = min(openingTime.count, closingTime.count)
    for i in 0..<cnt {
      res += "\(formattedTime(i)), "
    }
    return res
  }

  func formattedTime(_ i: Int) -> String {
    if i >= openingTime.count || i >= closingTime.count {
      return i == 0 ? "Closed" : "optional"
    }
    return closed ? "Closed" : "\(formattedOpeningTime(i))-\(formattedClosingTime(i))"
  }

  func formattedOpeningTime(_ i: Int) -> String {
    i >= openingTime.count ? "" : dateComponentsFormatter.string(from: openingTime[i]) ?? ""
  }

  func formattedClosingTime(_ i: Int) -> String {
    i >= closingTime.count ? "" : dateComponentsFormatter.string(from: closingTime[i]) ?? ""
  }

  var dateComponentsFormatter: DateComponentsFormatter {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.zeroFormattingBehavior = .pad
    return formatter
  }
  
  var openingHoursCount: Int {
    min(openingTime.count, closingTime.count)
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
