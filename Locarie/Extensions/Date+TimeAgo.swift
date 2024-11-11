//
//  Date+TimeAgo.swift
//  locarie
//
//  Created by qiuty on 26/05/2024.
//

import Foundation

extension Date {
  func timeAgoString() -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let components = calendar.dateComponents(
      [.second, .minute, .hour, .day, .month, .year], from: self, to: Date.now
    )

    return if let years = components.year, years > 0 {
      formatter.string(from: self)
    } else if let months = components.month, months > 0 {
      "\(months) month\(months == 1 ? "" : "s") ago"
    } else if let days = components.day, days > 0 {
      "\(days) day\(days == 1 ? "" : "s") ago"
    } else if let hours = components.hour, hours > 0 {
      "\(hours) hour\(hours == 1 ? "" : "s") ago"
    } else if let minutes = components.minute, minutes > 0 {
      "\(minutes) min\(minutes == 1 ? "" : "s") ago"
    } else if let seconds = components.second, seconds > 0 {
      "\(seconds) second\(seconds == 1 ? "" : "s") ago"
    } else {
      "Just now"
    }
  }
}
